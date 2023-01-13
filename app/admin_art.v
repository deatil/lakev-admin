module app

import vweb
import mkg.http.response

// 列表
['/admin/art/index'; get]
pub fn (mut app App) admin_art_index() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }

    
    return $vweb.html()
}

// 添加
['/admin/art/create'; get]
pub fn (mut app App) admin_art_create() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }

    
    return $vweb.html()
}

// 添加保存
['/admin/art/create'; post]
pub fn (mut app App) admin_art_create_save() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '保存失败', '')
    }

    
    return response.return_json(mut app.Context, 0, '保存成功', '')
}

// 编辑
['/admin/art/update'; get]
pub fn (mut app App) admin_art_update() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }

    
    return $vweb.html()
}

// 编辑保存
['/admin/art/update'; post]
pub fn (mut app App) admin_art_update_save() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '编辑失败', '')
    }

    
    return response.return_json(mut app.Context, 1, '编辑成功', '')
}

// 删除
['/admin/art/delete'; post]
pub fn (mut app App) admin_art_delete() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '删除失败', '')
    }

    
    return response.return_json(mut app.Context, 1, '删除成功', '')
}
