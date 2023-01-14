module vsession

import os
import toml
import time
import rand
import json
import mkg.log
import mkg.time as lakev_time

// 存储数据
pub struct SessionData {
    time i64
    data map[string]string
}

// 文件存储
pub struct SessionStoreFile {
mut:
    save_path      string = './tmp'
    gc_probability i64    = 1
    gc_divisor     i64    = 1000
    gc_maxlifetime i64    = 1440
}

// 构造函数
pub fn new_session_store_file(conf toml.Doc) &SessionStoreFile {
    save_path      := conf.value('session.file_save_path').string()
    gc_probability := conf.value('session.gc_probability').i64()
    gc_divisor     := conf.value('session.gc_divisor').i64()
    gc_maxlifetime := conf.value('session.gc_maxlifetime').i64()

    mut store := &SessionStoreFile{
        save_path:      save_path,
        gc_probability: gc_probability,
        gc_divisor:     gc_divisor,
        gc_maxlifetime: gc_maxlifetime,
    }
    
    return store
}

pub fn (mut s SessionStoreFile) get(key string) map[string]string {
    res := s.get_file(key)

    return res.data
}

pub fn (mut s SessionStoreFile) set(key string, value map[string]string) {
    time_unix := lakev_time.now().to_time().unix

    mut data := SessionData{
        time: time_unix
        data: value
    }

    encoded := json.encode(data)
    
    save_path := os.real_path(s.save_path)
    file_name := os.join_path(save_path, key)
    
    // 创建目录
    os.mkdir_all(save_path) or {}
    
    os.write_file(file_name, encoded) or {
        log.error(err.msg())
    }
}

// 回收过期数据
pub fn (s SessionStoreFile) gc() {
    value := rand.i64_in_range(i64(1), s.gc_divisor) or { i64(1) }
    if s.gc_probability >= value {
        task := go s.session_gc(s.gc_maxlifetime)
        task.wait()  or {}
    }
}

fn (s SessionStoreFile) get_file(key string) SessionData {
    file_name := os.join_path(os.real_path(s.save_path), key)
    
    payload := os.read_file(file_name) or { '' }

    res := json.decode(SessionData, payload) or { 
        return SessionData{} 
    }

    return res
}

// 回收
fn (s SessionStoreFile) session_gc(max_lifetime i64) ! {
    os.chdir(os.real_path(s.save_path)) or {}
    matches := os.glob('*') or { []string{} }
    
    now_time := lakev_time.now().to_time()
    max_lifetime_duration := time.Duration(max_lifetime * time.second)
    
    for _, name in matches {
        new_name := os.file_name(name)
    
        data := s.get_file(new_name)
        data_time := lakev_time.from_unix(data.time).to_time()
        data_time2 := data_time.add(max_lifetime_duration)
        
        // 添加时间后超过当前时间删除
        if now_time.unix > data_time2.unix {
            file_name := os.join_path(os.real_path(s.save_path), new_name)
            os.rm(file_name) or {}
        }
    }
}
