module app

import vweb

// 列表
['/admin/user/index'; get]
pub fn (mut app App) admin_user_index() vweb.Result {
    
    return $vweb.html()
}

// 添加
['/admin/user/create'; get]
pub fn (mut app App) admin_user_create() vweb.Result {
    
    return $vweb.html()
}

// 添加保存
['/admin/user/create'; post]
pub fn (mut app App) admin_user_create_save() vweb.Result {
    
    return app.return_json(1, '保存成功', '')
}

// 编辑
['/admin/user/update'; get]
pub fn (mut app App) admin_user_update() vweb.Result {
    
    return $vweb.html()
}

// 编辑保存
['/admin/user/update'; post]
pub fn (mut app App) admin_user_update_save() vweb.Result {
    
    return app.return_json(1, '编辑成功', '')
}

// 删除
['/admin/user/delete'; post]
pub fn (mut app App) admin_user_delete() vweb.Result {
    
    return app.return_json(1, '删除成功', '')
}
