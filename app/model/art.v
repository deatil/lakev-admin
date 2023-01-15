module model

import sqlite
import mkg.time

pub struct Art {
pub:
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

// 格式化时间
pub fn (art Art) format_date() string {
    t := time.from_unix(art.add_time)
    
    return t.to_date_time_string()
}

// 更改基础信息
pub fn updata_art(db sqlite.DB, id int, art Art) {
    sql db {
        update Art set cate_id = art.cate_id, 
            title = art.title, 
            keywords = art.keywords, 
            desc = art.desc, 
            content = art.content, 
            cover = art.cover, 
            tags = art.tags, 
            from = art.from, 
            status = art.status where id == id
    }
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

// 获取全部
pub fn find_all_art(db sqlite.DB) []Art {
    data := sql db {
        select from Art order by add_time desc
    }
    
    return data
}

// 获取
pub fn find_all_art_page(db sqlite.DB, page_num int, num_per int) ([]Art, int) {
    offs := page_num * num_per
    
    data := sql db { 
        select from Art order by add_time desc limit num_per offset offs 
    }
    
    count := sql db {
        select count from Art
    }
    
    return data, count
}

// 获取
pub fn find_art_by_status(db sqlite.DB, status bool) ([]Art, int) {
    data := sql db {
        select from Art where status == status order by add_time desc
    }
    
    count := sql db {
        select count from Art where status == status
    }
    
    return data, count
}

// 获取
pub fn find_art_page_by_status(db sqlite.DB, page_num int, num_per int, status bool) ([]Art, int) {
    offs := page_num * num_per
    
    data := sql db { 
        select from Art where status == status order by add_time desc limit num_per offset offs 
    }
    
    count := sql db {
        select count from Art where status == status
    }
    
    return data, count
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