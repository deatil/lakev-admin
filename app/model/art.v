module model

import sqlite

pub struct Art {
    id       int    [primary; sql: serial]
    cate_id  int  
    user_id  int  
    cover    string  
    title    string  
    keywords string  
    desc     string  
    content  string  
    tags     string  
    from     string  
    views    i64  
    status   int
    add_time i64
    add_ip   string
}

// 更改基础信息
pub fn updata_art_by_id(db sqlite.DB, id int, title string, keywords string, desc string, content string) {
    sql db {
        update Art set title = title, keywords = keywords, desc = desc, content = content where id == id
    }
}

// 更改状态
pub fn updata_art_status_by_id(db sqlite.DB, id int, status bool) {
    sql db {
        update Art set status = status where id == id
    }
}

// 创建
pub fn create_art(db sqlite.DB, art Art) {
    sql db {
        insert art into Art
    }
}

// 获取
pub fn get_art_by_id(db sqlite.DB, id int) Art {
    data := sql db {
        select from Art where id == id limit 1
    }

    if data.id == 0 {
        return Art{}
    }
    
    return data
}

// 获取
pub fn find_art_by_status(db sqlite.DB, status bool) []Art {
    data := sql db {
        select from Art where status == status order by add_time desc
    }
    
    return data
}

// 获取数量
pub fn get_art_count(db sqlite.DB) int {
    return sql db {
        select count from Art
    }
}

// 删除账号信息
pub fn delete_art_by_id(db sqlite.DB, id int) {
    sql db {
        delete from Art where id == id
    }
}