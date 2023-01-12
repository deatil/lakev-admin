module app

import vweb
import net.http
import mkg.time
import mkg.session
import app.model

struct ResultJson {
    code    int 
    message string
    data    string
}

// 返回 json
pub fn (mut app App) return_json(code int, message string, data string) vweb.Result {
    res := ResultJson{
        code:    code 
        message: message
        data:    data
    }

    return app.json(res)
}

// =================

// Gets a cookie by a key
pub fn (app &App) get_cookie(key string) !string { // TODO refactor
    mut cookie_header := app.get_header('cookie')
    if cookie_header == '' {
        cookie_header = app.get_header('Cookie')
    }
    cookie_header = ' ' + cookie_header
    
    // println('cookie_header="$cookie_header"')
    // println(app.req.header)
    cookie := if cookie_header.contains(';') {
        cookie_header.find_between(' ${key}=', ';')
    } else {
        cookie_header.find_between(' ${key}=', '\r')
    }
    if cookie != '' {
        return cookie.trim_space()
    }
    return error('Cookie not found')
}

// 覆盖设置 cookie
pub fn (mut app App) set_cookie(cookie http.Cookie) {
    data := app.build_cookie(cookie)
    app.add_header('Set-Cookie', '${data}')
}

pub fn (app &App) build_cookie(c http.Cookie) string {
    mut val := c.name + '=' + c.value
    if c.expires.year != 0 {
        val += '; Expires=' + c.expires.utc_string()
    }
    
    if c.expires.year > 1600 {
        e := c.expires
        time_str := '${e.weekday_str()}, ${e.day.str()} ${e.smonth()} ${e.year} ${e.hhmmss()} GMT'
        val += '; Expires=' + time_str
    }

    if c.max_age != -1 {
        val += '; Max-Age=' + c.max_age.str()
    }

    if c.domain.len > 0 {
        val += '; Domain=' + c.domain
    }
    if c.path.len > 0 {
        val += '; Path=' + c.path
    }
    if c.http_only {
        val += '; HttpOnly'
    }
    if c.secure || c.same_site == .same_site_default_mode {
        val += '; Secure'
    }
    if c.same_site != http.SameSite.same_site_default_mode {
        match c.same_site {
            .same_site_default_mode {
                val += '; SameSite'
            }
            .same_site_none_mode {
                val += '; SameSite=None'
            }
            .same_site_lax_mode {
                val += '; SameSite=Lax'
            }
            .same_site_strict_mode {
                val += '; SameSite=Strict'
            }
        }
    }
    return val
}

// =================

// app_name
pub fn (mut app App) app_name() string {
    return app.app_name
}

// 当前时间
pub fn (mut app App) now_time() time.Time {
    return time.now()
}

// 是否登录
pub fn (mut app App) is_login() bool {
    mut sess := session.session(app)
    
    userid := sess.get('userid')
    if userid == '' {
        return false
    }
    
    return true
}

// 登录账号信息
pub fn (mut app App) user_info() model.User {
    mut sess := session.session(app)
    
    userid := sess.get('userid')
    println(userid)
    if userid == '' {
        return model.User{}
    }
    
    user := model.get_user_by_id(app.db, userid.int())
    
    return user
}
