module app

import vweb

// 设置
['/admin/profile'; get]
pub fn (mut app App) admin_profile_setting() vweb.Result {
    
    return $vweb.html()
}

// 设置保存
['/admin/profile'; post]
pub fn (mut app App) admin_profile_setting_save() vweb.Result {
    
    return app.return_json(1, '保存成功', '')
}
