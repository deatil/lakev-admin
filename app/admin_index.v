module app

import vweb

// 后台首页
['/admin/index'; get]
pub fn (mut app App) admin_index_index() vweb.Result {
    return $vweb.html()
}

// 后台首页
['/admin/welcome'; get]
pub fn (mut app App) admin_index_welcome() vweb.Result {
    return $vweb.html()
}
