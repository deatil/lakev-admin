module vsession

import rand
import time
import net.http
import mkg.utils
import mkg.time as lakev_time

const default_cookie_name = 'vid'

// 存储接口
pub interface SessionStore {
    // 回收
    gc()
mut:
    // 获取
    get(key string) map[string]string
    // 设置
    set(key string, value map[string]string)
}

// Cookie接口
pub interface SessionCookie {
    get_cookie(key string) !string
mut:
    set_cookie(cookie http.Cookie)
}

// 存储数据
pub struct SessionData {
    time i64
    data map[string]string
}

/*
pub struct Cookie {
pub mut:
    name        string
    value       string
    path        string    // optional
    domain      string    // optional
    expires     time.Time // optional
    raw_expires string    // for reading cookies only. optional.
    max_age   int
    secure    bool
    http_only bool
    // http.SameSite.same_site_default_mode
    // same_site_lax_mode | same_site_strict_mode | same_site_none_mode
    same_site http.SameSite
    raw       string
    unparsed  []string // Raw text of unparsed attribute-value pairs
}
*/

// session
// save_handler = file
// save_path = ''
// save_path = ''
pub struct Session {
pub mut:
    // cookie 存储的名称
    cookie_name string
    
    // 最大存活时间
    gc_maxlifetime i64
    
    // 存储方式
    store SessionStore
    
    // cookie
    cookie SessionCookie
}

// 构造函数
pub fn new_session() &Session {
    mut sess := &Session{
        cookie: &SessionCookieEmpty{}
        store:  &SessionStoreFile{}
        cookie_name: default_cookie_name
    }
    
    return sess
}

// 启动
pub fn (mut s Session) start(mut cookie http.Cookie) {
    session_id := s.get_session_id()
    
    if session_id == '' {
        cookie.name = s.get_cookie_name()
        cookie.value = s.generate_session_id()
        
        s.cookie.set_cookie(cookie)
    }
}

pub fn (mut s Session) get(key string) string {
    session_id := s.get_session_id()
    if session_id == '' {
        return ''
    }
    
    mut store := s.get_store()

    store_data := store.get(session_id)
    
    data := store_data[key] or { '' }
    
    // 回收
    // s.gc()
    
    return data
}

pub fn (mut s Session) set(key string, value string) {
    session_id := s.get_session_id()
    if session_id == '' {
        return
    }
    
    mut store := s.get_store()
    
    mut store_data := store.get(session_id)
    store_data[key] = value

    store.set(session_id, store_data)
}

pub fn (mut s Session) delete(key string) {
    session_id := s.get_session_id()
    if session_id == '' {
        return
    }
    
    mut store := s.get_store()
    
    mut store_data := store.get(session_id)
    store_data.delete(key)

    store.set(session_id, store_data)
}

// 回收过期数据
fn (mut s Session) gc() {
    mut store := s.get_store()
    
    store.gc()
}

// 设置存储方式
pub fn (mut s Session) set_store(mut store SessionStore) {
    s.store = store
}

// 获取存储方式
fn (mut s Session) get_store() SessionStore {
    return s.store
}

// 设置 cookie 名称
fn (mut s Session) set_cookie_name(name string) {
    s.cookie_name = name
}

// 获取 cookie 名称
fn (s Session) get_cookie_name() string {
    mut cookie_name := s.cookie_name
    if cookie_name == '' {
        cookie_name = default_cookie_name
    }

    return cookie_name
}

// 获取 cookie 的 id
fn (s Session) get_session_id() string {
    cookie_name := s.get_cookie_name()

    id := s.cookie.get_cookie(cookie_name) or { '' }
    
    return id
}

// 生成 session_id
fn (s Session) generate_session_id() string {
    id := utils.md5(rand.uuid_v4())
    
    return id
}

pub fn get_same_site_mode(mode string) http.SameSite {
    return match mode {
        'lax' { http.SameSite.same_site_lax_mode }
        'strict' { http.SameSite.same_site_strict_mode }
        'none' { http.SameSite.same_site_none_mode }
        else { http.SameSite.same_site_default_mode }
    }
}

// SessionCookieEmpty
pub struct SessionCookieEmpty {
}

pub fn (s SessionCookieEmpty) get_cookie(key string) !string {
    return ''
}

pub fn (mut s SessionCookieEmpty) set_cookie(cookie http.Cookie) {
}

// SessionGCData
pub struct SessionGCData {
    name string
    data SessionData
}

// 数据回收
pub fn list_gc(matches []SessionGCData, max_lifetime i64, delete_fn fn(string)) {
    now_time := lakev_time.now().to_time()
    max_lifetime_duration := time.Duration(max_lifetime * time.second)
    
    for _, v in matches {
        key := v.name
        data := v.data
    
        data_time := lakev_time.from_unix(data.time).to_time()
        data_time2 := data_time.add(max_lifetime_duration)
        
        // 添加时间后超过当前时间删除
        if now_time.unix > data_time2.unix {
            delete_fn(key)
        }
    }
}
