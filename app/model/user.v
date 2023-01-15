module model

import sqlite
import mkg.time

pub struct User {
pub:
    id         int     [primary; sql: serial]
    username   string
    password   string
    nickname   string
    avatar     string
    status     int
    add_time   i64
    add_ip     string
}

// 格式化时间
pub fn (user User) format_date() string {
    t := time.from_unix(user.add_time)
    
    return t.to_date_time_string()
}

// 更改信息
pub fn updata_user(db sqlite.DB, user_id int, username string, nickname string, pass string, status int) {
    sql db {
        update User set username = username, nickname = nickname, password = pass, status = status where id == user_id
    }
}

// 更改信息
pub fn updata_user_info(db sqlite.DB, user_id int, nickname string, pass string) {
    sql db {
        update User set nickname = nickname, password = pass where id == user_id
    }
}

// 更改密码
pub fn updata_user_password(db sqlite.DB, user_id int, pass string) {
    sql db {
        update User set password = pass where id == user_id
    }
}

// 更改昵称
pub fn updata_user_nickname(db sqlite.DB, user_id int, nickname string) {
    sql db {
        update User set nickname = nickname where id == user_id
    }
}

// 创建账号
pub fn create_user(db sqlite.DB, user User) {
    sql db {
        insert user into User
    }
}

// 获取账号
pub fn get_user_by_id(db sqlite.DB, user_id int) User {
    data := sql db {
        select from User where id == user_id limit 1
    }

    if data.id == 0 {
        return User{}
    }
    
    return data
}

// 获取账号
pub fn get_user_by_username(db sqlite.DB, name string) User {
    data := sql db {
        select from User where username == name limit 1
    }
    
    return data
}

// 获取全部
pub fn find_all_user(db sqlite.DB) []User {
    data := sql db {
        select from User order by add_time desc
    }
    
    return data
}

// 获取
pub fn find_all_user_page(db sqlite.DB, page_num int, num_per int) ([]User, int) {
    offs := page_num * num_per
    
    data := sql db { 
        select from User order by add_time desc limit num_per offset offs 
    }
    
    count := sql db {
        select count from User
    }
    
    return data, count
}

// 获取
pub fn find_user_by_status(db sqlite.DB, status bool) ([]User, int) {
    data := sql db {
        select from User where status == status order by add_time desc
    }
    
    count := sql db {
        select count from User where status == status
    }
    
    return data, count
}

// 获取
pub fn find_user_page_by_status(db sqlite.DB, page_num int, num_per int, status bool) ([]User, int) {
    offs := page_num * num_per
    
    data := sql db { 
        select from User where status == status order by add_time desc limit num_per offset offs 
    }
    
    count := sql db {
        select count from User where status == status
    }
    
    return data, count
}

// 获取账号数量
pub fn get_user_count(db sqlite.DB) int {
    return sql db {
        select count from User
    }
}

// 删除账号信息
pub fn delete_user_by_id(db sqlite.DB, user_id int) {
    sql db {
        delete from User where id == user_id
    }
}