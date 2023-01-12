module app

import vweb

// 列表
['/admin/art/index'; get]
pub fn (mut app App) admin_art_index() vweb.Result {
    
    return $vweb.html()
}

// 添加
['/admin/art/create'; get]
pub fn (mut app App) admin_art_create() vweb.Result {
    
    return $vweb.html()
}

// 添加保存
['/admin/art/create'; post]
pub fn (mut app App) admin_art_create_save() vweb.Result {
    
    return app.return_json(1, '保存成功', '')
}

// 编辑
['/admin/art/update'; get]
pub fn (mut app App) admin_art_update() vweb.Result {
    
    return $vweb.html()
}

// 编辑保存
['/admin/art/update'; post]
pub fn (mut app App) admin_art_update_save() vweb.Result {
    
    return app.return_json(1, '编辑成功', '')
}

// 删除
['/admin/art/delete'; post]
pub fn (mut app App) admin_art_delete() vweb.Result {
    
    return app.return_json(1, '删除成功', '')
}
