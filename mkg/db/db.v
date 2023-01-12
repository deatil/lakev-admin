module db

import sqlite
import mkg.cfg

// mysql 数据库
pub fn connect() sqlite.DB {
    conf := cfg.config()
    
    mut connection := sqlite.connect(conf.value('db.sqlite').string()) or { panic(err) }

    return connection
}

