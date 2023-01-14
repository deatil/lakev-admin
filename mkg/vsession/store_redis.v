module vsession

import toml
import json
import time
import net.urllib
import mkg.log
import mkg.pkg.vredis

// redis 存储
pub struct SessionStoreRedis {
mut:
    redis        vredis.Redis
    prefix       string
    max_lifetime int
}

// 构造函数
pub fn new_session_store_redis(conf toml.Doc) &SessionStoreRedis {
    mut opts := vredis.ConnOpts{}
    
    opts.host = conf.value('session.redis_host').string()
    opts.port = conf.value('session.redis_port').int()
    opts.db   = conf.value('session.redis_db').int()
    opts.password      = conf.value('session.redis_password').string()
    opts.read_timeout  = conf.value('session.redis_read_timeout').i64() * time.second
    opts.write_timeout = conf.value('session.redis_write_timeout').i64() * time.second
    
    mut redis := vredis.connect(opts) or {
        log.error(err.msg())
        panic(err)
    }
    
    prefix       := conf.value('session.redis_prefix').string()
    max_lifetime := conf.value('session.gc_maxlifetime').int()

    mut store := &SessionStoreRedis{
        redis:        redis,
        prefix:       prefix,
        max_lifetime: max_lifetime,
    }
    
    return store
}

pub fn (mut s SessionStoreRedis) get(key string) map[string]string {
    new_key := '${s.prefix}:$key' 

    payload := s.redis.get(new_key) or { '' }
    escape_payload := urllib.query_unescape(payload) or { '' }

    res := json.decode(map[string]string, escape_payload) or { 
        return map[string]string{} 
    }

    return res
}

pub fn (mut s SessionStoreRedis) set(key string, value map[string]string) {
    new_key := '${s.prefix}:$key' 
    
    encoded := json.encode(value)
    escape_encoded := urllib.query_escape(encoded)

    s.redis.set(new_key, escape_encoded) or {
        log.error(err.msg())
    }
}

// 回收过期数据
pub fn (s SessionStoreRedis) gc() {
    // redis 不需要回收
}
