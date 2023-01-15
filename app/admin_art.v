module app

import vweb
import math
import time
import arrays
import mkg.http.response
import app.model

// 列表
['/admin/art/index'; get]
pub fn (mut app App) admin_art_index() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    mut page := if app.query['page'] != '' { app.query['page'].int() } else { 1 }
    page = arrays.max([1, page]) or { 1 }
    
    arts, count := model.find_all_art_page(app.db, page - 1, app.pagesize)
    
    page_count := math.ceil(count / app.pagesize)
    
    return $vweb.html()
}

// 添加
['/admin/art/create'; get]
pub fn (mut app App) admin_art_create() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }

    cates := model.find_all_cate(app.db)
    
    return $vweb.html()
}

// 添加保存
['/admin/art/create'; post]
pub fn (mut app App) admin_art_create_save() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '请先登录', '')
    }

    form_cate_id := app.form['cate_id']
    form_title := app.form['title']
    
    if form_cate_id == '' {
        return response.return_json(mut app.Context, 1, '文章分类不能为空', '')
    }
    if form_title == '' {
        return response.return_json(mut app.Context, 1, '文章标题不能为空', '')
    }
    
    t := time.now()
    
    art := model.Art{
        cate_id: form_cate_id.int(),
        title: form_title,
        keywords: '',
        desc: '',
        content: '',
        cover: '',
        tags: '',
        from: '网络',
        status: 1,
        add_time: t.unix_time(),
        add_ip: app.ip(),
    }

    model.create_art(app.db, art)
    
    return response.return_json(mut app.Context, 0, '添加文章成功', '')
}

// 编辑
['/admin/art/update'; get]
pub fn (mut app App) admin_art_update() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    id := app.query['id']
    if id == '' {
        return app.html('文章ID不能为空')
    }

    art_info := model.get_art_by_id(app.db, id.int())
    if art_info.id == 0 {
        return app.html('文章不存在')
    }
    
    cates := model.find_all_cate(app.db)
    
    return $vweb.html()
}

// 编辑保存
['/admin/art/update'; post]
pub fn (mut app App) admin_art_update_save() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '请先登录', '')
    }
    
    id := app.query['id']
    if id == '' {
        return response.return_json(mut app.Context, 1, '文章ID不能为空', '')
    }

    form_cate_id := app.form['cate_id']
    form_title := app.form['title']
    form_keywords := app.form['keywords'] or { '' }
    form_desc := app.form['desc'] or { '' }
    form_content := app.form['content']
    form_tags := app.form['tags'] or { '' }
    form_from := app.form['from'] or { '' }
    form_status := app.form['status'] or { '1' }
    
    if form_cate_id == '' {
        return response.return_json(mut app.Context, 1, '文章分类不能为空', '')
    }
    if form_title == '' {
        return response.return_json(mut app.Context, 1, '文章标题不能为空', '')
    }
    if form_content == '' {
        return response.return_json(mut app.Context, 1, '文章内容不能为空', '')
    }
    if !(form_status in ['1', '0']) {
        return response.return_json(mut app.Context, 1, '文章状态错误', '')
    }
    
    art_info := model.get_art_by_id(app.db, id.int())
    if art_info.id == 0 {
        return app.html('文章不存在')
    }
    
    art := model.Art{
        cate_id: form_cate_id.int(),
        title: form_title,
        keywords: form_keywords,
        desc: form_desc,
        content: form_content,
        cover: '',
        tags: form_tags,
        from: form_from,
        status: form_status.int(),
    }

    model.updata_art(app.db, id.int(), art)
    
    return response.return_json(mut app.Context, 1, '编辑文章成功', '')
}

// 删除
['/admin/art/delete'; post]
pub fn (mut app App) admin_art_delete() vweb.Result {
    if !app.is_login() {
        return response.return_json(mut app.Context, 1, '请先登录', '')
    }
    
    id := app.form['id']
    if id == '' {
        return response.return_json(mut app.Context, 1, '文章ID不能为空', '')
    }
    
    model.delete_art_by_id(app.db, id.int())
    
    return response.return_json(mut app.Context, 1, '删除文章成功', '')
}
