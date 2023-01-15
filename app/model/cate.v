module model

import sqlite
import mkg.time

pub struct Cate {
pub:
    id       int    [primary; sql: serial]
    name     string  
    slug     string [unique]
    order    int
    status   int
    add_time i64
    add_ip   string
}

// 格式化时间
pub fn (cate Cate) format_date() string {
    t := time.from_unix(cate.add_time)
    
    return t.to_date_time_string()
}

// 更改基础信息
pub fn updata_cate_by_id(db sqlite.DB, id int, name string, slug string, order int, status int) {
    sql db {
        update Cate set name = name, slug = slug, order = order, status = status where id == id
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

// 获取全部
pub fn find_all_cate(db sqlite.DB) []Cate {
    data := sql db {
        select from Cate order by add_time desc
    }
    
    return data
}

// 获取
pub fn find_all_cate_page(db sqlite.DB, page_num int, num_per int) ([]Cate, int) {
    offs := page_num * num_per
    
    data := sql db { 
        select from Cate order by add_time desc limit num_per offset offs 
    }
    
    count := sql db {
        select count from Cate
    }
    
    return data, count
}

// 获取
pub fn find_cate_by_status(db sqlite.DB, status bool) ([]Cate, int) {
    data := sql db {
        select from Cate where status == status order by add_time desc
    }
    
    count := sql db {
        select count from Cate where status == status
    }
    
    return data, count
}

// 获取
pub fn find_cate_page_by_status(db sqlite.DB, page_num int, num_per int, status bool) ([]Cate, int) {
    offs := page_num * num_per
    
    data := sql db { 
        select from Cate where status == status order by add_time desc limit num_per offset offs 
    }
    
    count := sql db {
        select count from Cate where status == status
    }
    
    return data, count
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