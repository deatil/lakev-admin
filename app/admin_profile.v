module app

import vweb
import mkg.auth
import mkg.http.response
import app.model

// 设置
['/admin/profile'; get]
pub fn (mut app App) admin_profile_setting() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    user := app.user_info()
    
    return $vweb.html()
}

// 设置保存
['/admin/profile'; post]
pub fn (mut app App) admin_profile_setting_save() vweb.Result {
    if !app.is_login() {
        return app.r_login()
    }
    
    user := app.user_info()
    
    form_nickname := app.form['nickname']
    if form_nickname == '' {
        return response.return_json(mut app.Context, 1, '昵称不能为空', '')
    }
    
    form_oldpass := app.form['oldpass']
    form_newpass := app.form['newpass']
    if form_newpass != '' {
        if form_oldpass == '' {
            return response.return_json(mut app.Context, 1, '旧密码不能为空', '')
        }
        
        if !auth.compare_password(form_oldpass, user.password) {
            return response.return_json(mut app.Context, 1, '旧密码错误', '')
        }

        if form_newpass.len < 6 || form_newpass.len > 12 {
            return response.return_json(mut app.Context, 1, '新密码必须6到12位', '')
        }
        
        newpass := auth.hash_password(form_newpass)
    
        model.updata_user_info(app.db, user.id, form_nickname, newpass)
    
        return response.return_json(mut app.Context, 1, '更改信息成功', '')
    }
    
    model.updata_user_nickname(app.db, user.id, form_nickname)
    
    return response.return_json(mut app.Context, 1, '更改信息成功', '')
}
