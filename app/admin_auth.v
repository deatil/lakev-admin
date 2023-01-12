module app

import vweb
import mkg.session
import app.model

// 登录
['/admin/auth/login'; get]
pub fn (mut app App) admin_auth_login() vweb.Result {
    app_name := app.app_name
    
    return $vweb.html()
}

// 登录确认
['/admin/auth/login'; post]
pub fn (mut app App) admin_auth_login_check() vweb.Result {
    user := model.get_user_by_username(app.db, 'admin')
    println(user)


    userid := '123'
    mut sess := session.session(app)
    sess.set('userid', userid)

    return app.return_json(1, '登录成功', '')
}

// 退出
['/admin/auth/logout'; get]
pub fn (mut app App) admin_auth_logout() vweb.Result {
    // 退出
    mut sess := session.session(app)
    sess.delete('userid')

    return app.redirect('/admin/auth/login')
}
