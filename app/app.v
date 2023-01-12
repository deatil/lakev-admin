module app

import vweb
import time
import sqlite
import mkg.db
import mkg.cfg
import mkg.session

struct App {
    vweb.Context
    started_at i64 [vweb_global]
pub mut:
    db sqlite.DB
mut:
    app_name string [vweb_global]
    version  string [vweb_global]
    debug    bool [vweb_global]
}

pub fn (app App) before_request() {
    // 添加 session
    session.start(app)

    println('[vweb] before_request: ${app.req.method} ${app.req.url}')
}

// 实例化
pub fn new_app() &App {
    mut app := &App{
        db: db.connect()
        started_at: time.now().unix
    }
    
    conf := cfg.config()
    
    app.app_name = conf.value('app.app_name').string()
    app.version  = conf.value('app.version').string()
    app.debug    = conf.value('app.debug').bool()

    return app
}

struct ResultJson {
    code    int 
    message string
    data    string
}

pub fn (mut app App) return_json(code int, message string, data string) vweb.Result {
    res := ResultJson{
        code:    code 
        message: message
        data:    data
    }

    return app.json(res)
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