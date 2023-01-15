module app

import vweb
import math
import time
import arrays
import mkg.auth
import mkg.http.response
import app.model

// 列表
['/admin/user/index'; get]
pub fn (mut app App) admin_user_index() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    mut page := if app.query['page'] != '' { app.query['page'].int() } else { 1 }
    page = arrays.max([1, page]) or { 1 }
    
    users, count := model.find_all_user_page(app.db, page - 1, app.pagesize)
    
    page_count := math.ceil(count / app.pagesize)
    
    return $vweb.html()
}

// 添加
['/admin/user/create'; get]
pub fn (mut app App) admin_user_create() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    return $vweb.html()
}

// 添加保存
['/admin/user/create'; post]
pub fn (mut app App) admin_user_create_save() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '请先登录', '')
    }

    form_username := app.form['username']
    form_nickname := app.form['nickname']
    
    if form_username == '' {
        return response.return_json(mut app.Context, 1, '账号不能为空', '')
    }
    if form_nickname == '' {
        return response.return_json(mut app.Context, 1, '账号昵称不能为空', '')
    }
    
    user_info := model.get_user_by_username(app.db, form_username)
    if user_info.id > 0 {
        return response.return_json(mut app.Context, 1, '账号[${form_username}]已经存在', '')
    }
    
    t := time.now()
    
    user := model.User{
        username: form_username,
        password: '',
        nickname: form_nickname,
        avatar: '',
        status: 1,
        add_time: t.unix_time(),
        add_ip: app.ip(),
    }

    model.create_user(app.db, user)
   
    return response.return_json(mut app.Context, 1, '添加账号成功', '')
}

// 编辑
['/admin/user/update'; get]
pub fn (mut app App) admin_user_update() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    id := app.query['id']
    if id == '' {
        return app.html('账号ID不能为空')
    }

    user_info := model.get_user_by_id(app.db, id.int())
    if user_info.id == 0 {
        return app.html('账号不存在')
    }

    return $vweb.html()
}

// 编辑保存
['/admin/user/update'; post]
pub fn (mut app App) admin_user_update_save() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '请先登录', '')
    }
    
    id := app.query['id']
    if id == '' {
        return response.return_json(mut app.Context, 1, '账号ID不能为空', '')
    }
    
    if id == app.user_info().id.str() {
        return response.return_json(mut app.Context, 1, '你不能更改你自己的账号', '')
    }

    form_username := app.form['username']
    form_nickname := app.form['nickname']
    mut form_password := app.form['password'] or { '' }
    form_status := app.form['status']
    
    if form_username == '' {
        return response.return_json(mut app.Context, 1, '账号不能为空', '')
    }
    if form_nickname == '' {
        return response.return_json(mut app.Context, 1, '账号昵称不能为空', '')
    }
    if form_status == '' {
        return response.return_json(mut app.Context, 1, '账号状态不能为空', '')
    }
    if !(form_status in ['1', '0']) {
        return response.return_json(mut app.Context, 1, '账号状态错误', '')
    }
    
    user_info := model.get_user_by_id(app.db, id.int())
    if user_info.id == 0 {
        return app.html('账号不存在')
    }
    
    user_info2 := model.get_user_by_username(app.db, form_username)
    if user_info2.id > 0 && user_info2.id != id.int() {
        return response.return_json(mut app.Context, 1, '账号[${form_username}]已经存在', '')
    }
    
    if form_password != '' {
        form_password = auth.hash_password(form_password)
    } else {
        form_password = user_info.password
    }

    model.updata_user(app.db, id.int(), form_username, form_nickname, form_password, form_status.int())
    
    return response.return_json(mut app.Context, 1, '编辑账号成功', '')
}

// 删除
['/admin/user/delete'; post]
pub fn (mut app App) admin_user_delete() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '请先登录', '')
    }
    
    id := app.form['id']
    if id == '' {
        return response.return_json(mut app.Context, 1, '账号ID不能为空', '')
    }
    
    model.delete_user_by_id(app.db, id.int())
    
    return response.return_json(mut app.Context, 1, '删除成功', '')
}
