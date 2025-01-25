-- 设置一个复杂密码，防止校验不通过
-- alter user 'root'@'localhost' identified by '13&Uasdf!ahjsf' password expire never;

-- flush privileges;

-- 降低密码强度
-- SET GLOBAL validate_password.policy=LOW;
-- SET GLOBAL validate_password.length=1;


-- 更改root用户的密码，并将其设置为永不过期
-- alter user 'root'@'localhost' identified by 'yxx@12345678&mysql' password expire never;

-- 更改root密码并明确指定使用mysql_native_password认证插件
-- alter user 'root'@'localhost' identified with mysql_native_password by 'yxx@12345678&mysql';

-- 合并上述两条命令
ALTER USER 'root'@'localhost' 
IDENTIFIED WITH mysql_native_password BY 'yxx@12345678&mysql'
PASSWORD EXPIRE NEVER;

flush privileges;

use mysql;

-- 将用户名为root且主机名为localhost的记录的host字段改为%,允许root用户从任何主机连接到MySQL服务器
update user set host='%' where user='root' and host='localhost';

flush privileges;

exit
