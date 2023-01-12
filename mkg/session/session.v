module session

import net.http
import mkg.cfg
import mkg.vsession

const deafault_cfg_file = './config/cfg.toml'

// session_start
pub fn start(cookie vsession.SessionCookie) {
    mut sess := session(cookie)
    
    conf := cfg.config()

    mut vcookie := http.Cookie{
        path:      conf.value('session.cookie_path').string()
        domain:    conf.value('session.cookie_domain').string()
        http_only: conf.value('session.cookie_httponly').bool()
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
    sess.store = conf.value('session.save_handler').string()
    
    mut store_file := vsession.new_session_store_file()
    store_file.save_path = conf.value('session.save_path').string()
    store_file.gc_probability = conf.value('session.gc_probability').i64()
    store_file.gc_divisor = conf.value('session.gc_divisor').i64()
    sess.register_store('file', mut store_file)
    
    return sess
}
