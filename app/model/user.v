module model

import sqlite

pub struct User {
    id         int     [primary; sql: serial]
    username   string  [unique]
    password   string
    nickname   string
    avatar     string
    status     int
    add_time   i64
    add_ip     string
}

// 更改密码
pub fn updata_user_password(db sqlite.DB, user_id int, pass string) {
    sql db {
        update User set password = pass where id == user_id
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