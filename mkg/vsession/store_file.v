module vsession

import os
import toml
import rand
import json
import mkg.log
import mkg.time as lakev_time

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
    s.session_gc(s.gc_maxlifetime) or {}

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
    
    mut data_map := []SessionGCData{}
    
    for _, name in matches {
        new_name := os.file_name(name)
        new_data := s.get_file(new_name)
    
        data_map << SessionGCData{
            name: new_name,
            data: new_data,
        }
    }
    
    // 回收
    list_gc(data_map, s.gc_maxlifetime, fn[s](name string) {
        file_name := os.join_path(os.real_path(s.save_path), name)
        os.rm(file_name) or {}
    })
}
