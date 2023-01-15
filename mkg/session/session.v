module session

import time
import net.http
import mkg.cfg
import mkg.vsession

const deafault_cfg_file = './config/cfg.toml'

// session_start
pub fn start(cookie vsession.SessionCookie) {
    mut sess := session(cookie)
    
    conf := cfg.config()
    
    mut expires := time.Time{}
    cookie_expires := conf.value('session.cookie_expires').int()
    if cookie_expires > 0 {
        expires = time.now().add_seconds(cookie_expires)
    }

    mut vcookie := http.Cookie{
        path:      conf.value('session.cookie_path').string()
        domain:    conf.value('session.cookie_domain').string()
        http_only: conf.value('session.cookie_httponly').bool()
        expires:   expires
        max_age:   conf.value('session.cookie_lifetime').int()
        same_site: vsession.get_same_site_mode(conf.value('session.cookie_samesite').string())
    }
    
    sess.start(mut vcookie)
}

// session
pub fn session(cookie vsession.SessionCookie) &vsession.Session {
    conf := cfg.config()

    mut sess := vsession.new_session()
    sess.cookie_name = conf.value('session.cookie_cookie_name').string()
    sess.gc_maxlifetime = conf.value('session.gc_maxlifetime').i64()
    sess.cookie = cookie
    
    store := conf.value('session.save_handler').string()
    
    if store == 'file' {
        mut store_handler := vsession.new_session_store_file(conf)
        sess.set_store(mut store_handler)
    } else if store == 'redis' {
        mut store_handler := vsession.new_session_store_redis(conf)
        sess.set_store(mut store_handler)
    }
    
    return sess
}
