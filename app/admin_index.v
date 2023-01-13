module app

import os
import vweb
import sqlite
import app.model

// 后台首页
['/admin/index'; get]
pub fn (mut app App) admin_index_index() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }

    return $vweb.html()
}

/*
pub struct Uname {
pub mut:
    sysname  string
    nodename string
    release  string
    version  string
    machine  string
}
*/

// 后台首页
['/admin/welcome'; get]
pub fn (mut app App) admin_index_welcome() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    art_count := model.get_art_count(app.db)
    cate_count := model.get_cate_count(app.db)
    user_count := model.get_user_count(app.db)
    
    nr_cpus := 1
    
    sqlite_versions := app.db.exec_one('select sqlite_version();') or { sqlite.Row{} }
    sqlite_version := sqlite_versions.vals[0]
    
    // home_dir := os.home_dir()
    // hostname := os.hostname()
    
    user_os := os.user_os()
    uname := os.uname()

    return $vweb.html()
}
