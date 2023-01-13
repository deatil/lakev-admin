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
    debug    bool   [vweb_global]
    pagesize int    [vweb_global]
}

pub fn (mut app App) before_request() {
    // 开启 session
    session.start(app)

    println('[lakev-admin] before_request: ${app.req.method} ${app.req.url}')
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
    app.pagesize = conf.value('app.pagesize').int()

    return app
}
