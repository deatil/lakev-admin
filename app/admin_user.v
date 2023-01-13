module app

import vweb
import mkg.http.response

// 列表
['/admin/user/index'; get]
pub fn (mut app App) admin_user_index() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }

    
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
        return app.r_login()
    }

    
    return response.return_json(mut app.Context, 1, '保存成功', '')
}

// 编辑
['/admin/user/update'; get]
pub fn (mut app App) admin_user_update() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }

    
    return $vweb.html()
}

// 编辑保存
['/admin/user/update'; post]
pub fn (mut app App) admin_user_update_save() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }

    
    return response.return_json(mut app.Context, 1, '编辑成功', '')
}

// 删除
['/admin/user/delete'; post]
pub fn (mut app App) admin_user_delete() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    return response.return_json(mut app.Context, 1, '删除成功', '')
}
