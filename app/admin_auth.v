module app

import vweb
import mkg.auth
import mkg.session
import app.model

// 登录
['/admin/auth/login'; get]
pub fn (mut app App) admin_auth_login() vweb.Result {
    return $vweb.html()
}

// 登录确认
['/admin/auth/login'; post]
pub fn (mut app App) admin_auth_login_check() vweb.Result {
    form_username := app.form['username']
    form_password := app.form['password']
    
    if form_username == '' || form_password == '' {
        return app.return_json(1, '账号或者密码不能为空', '')
    }

    user := model.get_user_by_username(app.db, form_username)
    if user.id == 0 {
        return app.return_json(1, '账号或者密码错误', '')
    }
    
    if !auth.compare_password(form_password, user.password) {
        return app.return_json(1, '账号或者密码错误', '')
    }

    mut sess := session.session(app)
    sess.set('userid', user.id.str())

    return app.return_json(0, '登录成功', '')
}

// 退出
['/admin/auth/logout'; get]
pub fn (mut app App) admin_auth_logout() vweb.Result {
    // 退出
    mut sess := session.session(app)
    sess.delete('userid')

    return app.redirect('/admin/auth/login')
}
