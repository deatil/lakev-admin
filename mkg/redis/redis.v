module redis

import time
import mkg.cfg
import mkg.pkg.vredis

// redis
// 示例：
// import mkg.redis
// mut new_redis := redis.redis()
// new_redis.set('test 0', '123') or {}
pub fn redis() vredis.Redis {
    conf := cfg.config()

    mut opts := vredis.ConnOpts{}
    opts.host = conf.value('redis.host').string()
    opts.port = conf.value('redis.port').int()
    opts.db = conf.value('redis.db').int()
    opts.password = conf.value('redis.password').string()
    opts.read_timeout = conf.value('redis.read_timeout').i64() * time.second
    opts.write_timeout = conf.value('redis.write_timeout').i64() * time.second
    
    redis := vredis.connect(opts) or {
        panic(err)
    }
    
    return redis
}
