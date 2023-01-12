module main

import os
import vweb
import mkg.cfg
import mkg.log
import app

fn main() {
    // 打印信息
    print_info()
    
    // 运行
    mut app := app.new_app()
    app.serve_static('/favicon.ico', 'public/favicon.ico')
    os.chdir(os.dir(os.executable()))!
    app.handle_static('public/assets', true)

    // 运行信息
    host := cfg.config().value('app.server_host').string()
    port := cfg.config().value('app.server_port').int()
    
    vweb.run_at(app, vweb.RunParams{
        host: host
        port: port
        family: .ip
    }) or { log.fatal(err.msg()) }
}

// 打印信息
fn print_info() {
    logo := 'lakev-admin v1.0.1'
    
    println(logo)
}