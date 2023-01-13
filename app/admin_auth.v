module app

import vweb
import mkg.auth
import mkg.session
import mkg.http.response
import app.model

// 登录
['/admin/auth/login'; get]
pub fn (mut app App) admin_auth_login() vweb.Result {
    if app.is_login() {
        return app.redirect('/admin/index')
    }

    return $vweb.html()
}

// 登录确认
['/admin/auth/login'; post]
pub fn (mut app App) admin_auth_login_check() vweb.Result {
    if app.is_login() {
        return response.return_json(mut app.Context, 1, '你已经登录了', '')
    }

    form_username := app.form['username']
    form_password := app.form['password']
    
    if form_username == '' || form_password == '' {
        return response.return_json(mut app.Context, 1, '账号或者密码不能为空', '')
    }

    user := model.get_user_by_username(app.db, form_username)
    if user.id == 0 {
        return response.return_json(mut app.Context, 1, '账号或者密码错误', '')
    }
    
    if !auth.compare_password(form_password, user.password) {
        return response.return_json(mut app.Context, 1, '账号或者密码错误', '')
    }

    mut sess := session.session(app)
    sess.set('userid', user.id.str())

    return response.return_json(mut app.Context, 0, '登录成功', '')
}

// 退出
['/admin/auth/logout'; get]
pub fn (mut app App) admin_auth_logout() vweb.Result {
    // 退出
    mut sess := session.session(app)
    sess.delete('userid')

    return app.r_login()
}
