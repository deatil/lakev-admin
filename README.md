## lakev-admin 管理系统

lakev-admin 是使用 vweb 和 sqlite 的 vlang 后台管理系统


### 项目介绍

*  使用 `vlang` 语言开发的通用后台管理系统
*  核心使用 vweb 及 sqlite 等开发
*  模板使用 `X-admin` 后台模板开发，非前后端分离


### 环境要求

 - vlang >= 0.3.2
 - sqlite


### 安装步骤

1. 首先克隆项目到本地

```
git clone https://github.com/deatil/lakev-admin
```

2. 然后配置数据库等相关配置，配置位置

```
/config/cfg.toml
```

3. 运行测试

```
v run .
```

4. 后台登录账号及密码：`admin` / `123456`, 后台地址: `/admin/index`


### 开源协议

*  `lakev-admin` 遵循 `Apache2` 开源协议发布，在保留本系统版权的情况下提供个人及商业免费使用。


### 版权

*  该系统所属版权归 deatil(https://github.com/deatil) 所有。
