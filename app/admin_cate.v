module app

import vweb
import math
import time
import arrays
import mkg.http.response
import app.model

// 列表
['/admin/cate/index'; get]
pub fn (mut app App) admin_cate_index() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    mut page := if app.query['page'] != '' { app.query['page'].int() } else { 1 }
    page = arrays.max([1, page]) or { 1 }
    
    cates, count := model.find_all_cate_page(app.db, page - 1, app.pagesize)
    
    page_count := math.ceil(count / app.pagesize)
    
    return $vweb.html()
}

// 添加
['/admin/cate/create'; get]
pub fn (mut app App) admin_cate_create() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    return $vweb.html()
}

// 添加保存
['/admin/cate/create'; post]
pub fn (mut app App) admin_cate_create_save() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '请先登录', '')
    }

    form_name := app.form['name']
    form_slug := app.form['slug']
    
    if form_name == '' {
        return response.return_json(mut app.Context, 1, '分类名称不能为空', '')
    }
    if form_slug == '' {
        return response.return_json(mut app.Context, 1, '分类标识不能为空', '')
    }
    
    cate_info := model.get_cate_by_slug(app.db, form_slug)
    if cate_info.id > 0 {
        return response.return_json(mut app.Context, 1, '分类标识[${form_slug}]已经存在', '')
    }
    
    t := time.now()
    
    cate := model.Cate{
        name: form_name,
        slug: form_slug,
        order: 10,
        status: 1,
        add_time: t.unix_time(),
        add_ip: app.ip(),
    }

    model.create_cate(app.db, cate)
    
    return response.return_json(mut app.Context, 0, '添加成功', '')
}

// 编辑
['/admin/cate/update'; get]
pub fn (mut app App) admin_cate_update() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    id := app.query['id']
    if id == '' {
        return app.html('分类ID不能为空')
    }

    cate_info := model.get_cate_by_id(app.db, id.int())
    if cate_info.id == 0 {
        return app.html('分类不存在')
    }
    
    return $vweb.html()
}

// 编辑保存
['/admin/cate/update'; post]
pub fn (mut app App) admin_cate_update_save() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '请先登录', '')
    }
    
    id := app.query['id']
    if id == '' {
        return response.return_json(mut app.Context, 1, '分类ID不能为空', '')
    }

    form_name := app.form['name']
    form_slug := app.form['slug']
    form_order := app.form['order'] or { '10' }
    form_status := app.form['status']
    
    if form_name == '' {
        return response.return_json(mut app.Context, 1, '分类名称不能为空', '')
    }
    if form_slug == '' {
        return response.return_json(mut app.Context, 1, '分类标识不能为空', '')
    }
    if form_status == '' {
        return response.return_json(mut app.Context, 1, '分类状态不能为空', '')
    }
    if !(form_status in ['1', '0']) {
        return response.return_json(mut app.Context, 1, '分类状态错误', '')
    }
    
    cate_info := model.get_cate_by_id(app.db, id.int())
    if cate_info.id == 0 {
        return app.html('分类不存在')
    }
    
    cate_info2 := model.get_cate_by_slug(app.db, form_slug)
    if cate_info2.id > 0 && cate_info2.id != id.int() {
        return response.return_json(mut app.Context, 1, '分类标识[${form_slug}]已经存在', '')
    }

    model.updata_cate_by_id(app.db, id.int(), form_name, form_slug, form_order.int(), form_status.int())
    
    return response.return_json(mut app.Context, 0, '编辑成功', '')
}

// 删除
['/admin/cate/delete'; post]
pub fn (mut app App) admin_cate_delete() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '请先登录', '')
    }
    
    id := app.form['id']
    if id == '' {
        return response.return_json(mut app.Context, 1, '分类ID不能为空', '')
    }
    
    model.delete_cate_by_id(app.db, id.int())
    
    return response.return_json(mut app.Context, 0, '删除成功', '')
}
