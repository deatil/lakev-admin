module app

import vweb
// import mkg.time

// 列表
['/admin/cate/index'; get]
pub fn (mut app App) admin_cate_index() vweb.Result {
    
    return $vweb.html()
}

// 添加
['/admin/cate/create'; get]
pub fn (mut app App) admin_cate_create() vweb.Result {
    
    return $vweb.html()
}

// 添加保存
['/admin/cate/create'; post]
pub fn (mut app App) admin_cate_create_save() vweb.Result {
    
    return app.return_json(1, '保存成功', '')
}

// 编辑
['/admin/cate/update'; get]
pub fn (mut app App) admin_cate_update() vweb.Result {
    
    return $vweb.html()
}

// 编辑保存
['/admin/cate/update'; post]
pub fn (mut app App) admin_cate_update_save() vweb.Result {
    
    return app.return_json(1, '编辑成功', '')
}

// 删除
['/admin/cate/delete'; post]
pub fn (mut app App) admin_cate_delete() vweb.Result {
    
    return app.return_json(1, '删除成功', '')
}
