module model

import sqlite

pub struct Cate {
pub:
    id       int    [primary; sql: serial]
    name     string  
    slug     string [unique]
    sort     int
    status   int
    add_time i64
    add_ip   string
}

// 更改基础信息
pub fn updata_cate_by_id(db sqlite.DB, id int, name string, slug string, sort int) {
    sql db {
        update Cate set name = name, slug = slug, sort = sort where id == id
    }
}

// 更改状态
pub fn updata_cate_status_by_id(db sqlite.DB, id int, status bool) {
    sql db {
        update Cate set status = status where id == id
    }
}

// 创建
pub fn create_cate(db sqlite.DB, cate Cate) {
    sql db {
        insert cate into Cate
    }
}

// 获取
pub fn get_cate_by_id(db sqlite.DB, id int) Cate {
    data := sql db {
        select from Cate where id == id limit 1
    }

    if data.id == 0 {
        return Cate{}
    }
    
    return data
}

// 获取
pub fn get_cate_by_slug(db sqlite.DB, slug string) Cate {
    data := sql db {
        select from Cate where slug == slug limit 1
    }

    if data.id == 0 {
        return Cate{}
    }
    
    return data
}

// 获取数量
pub fn get_cate_count(db sqlite.DB) int {
    return sql db {
        select count from Cate
    }
}

// 删除信息
pub fn delete_cate_by_id(db sqlite.DB, id int) {
    sql db {
        delete from Cate where id == id
    }
}