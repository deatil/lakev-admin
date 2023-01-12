module vsession

// 空存储
pub struct SessionStoreEmpty {}

// 构造函数
pub fn new_session_store_empty() &SessionStoreEmpty {
    mut store := &SessionStoreEmpty{}
    
    return store
}

pub fn (s SessionStoreEmpty) get(key string) map[string]string {
    return map[string]string{}
}

pub fn (mut s SessionStoreEmpty) set(key string, value map[string]string) {

}

// 回收过期数据
pub fn (s SessionStoreEmpty) gc(max_lifetime i64) {

}
