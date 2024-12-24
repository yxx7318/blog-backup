# MySql用户权限

## 权限级别

- 全局：可以管理整个MySql
- 库：可以管理指定的数据库
- 表：可以管理指定的数据库的指定表
- 字段：可以管理指定数据库的指定表的指定字段

## 查看用户权限

查看所有用户：

```
SELECT user,host FROM mysql.user;
```

> ```
> mysql> SELECT user,host FROM mysql.user;
> +------------------+--------------+
> | user             | host         |
> +------------------+--------------+
> | cebc_wei         | %            |
> | litemall         | %            |
> | root             | %            |
> | slave_read       | %            |
> | repl             | 172.16.16.12 |
> | mysql.infoschema | localhost    |
> | mysql.session    | localhost    |
> | mysql.sys        | localhost    |
> +------------------+--------------+
> 8 rows in set (0.00 sec)
> ```

查看单个用户权限：

```
SELECT * FROM mysql.user WHERE user='root'\G
```

> `\G`无法直接在sql中使用

```
mysql> SELECT * FROM mysql.user WHERE user='root'\G
*************************** 1. row ***************************
                    Host: %
                    User: root
             Select_priv: Y
             Insert_priv: Y
             Update_priv: Y
             Delete_priv: Y
             Create_priv: Y
               Drop_priv: Y
             Reload_priv: Y
           Shutdown_priv: Y
            Process_priv: Y
               File_priv: Y
              Grant_priv: Y
         References_priv: Y
              Index_priv: Y
              Alter_priv: Y
            Show_db_priv: Y
              Super_priv: Y
   Create_tmp_table_priv: Y
        Lock_tables_priv: Y
            Execute_priv: Y
         Repl_slave_priv: Y
        Repl_client_priv: Y
        Create_view_priv: Y
          Show_view_priv: Y
     Create_routine_priv: Y
      Alter_routine_priv: Y
        Create_user_priv: Y
              Event_priv: Y
            Trigger_priv: Y
  Create_tablespace_priv: Y
                ssl_type:
              ssl_cipher:
             x509_issuer:
            x509_subject:
           max_questions: 0
             max_updates: 0
         max_connections: 0
    max_user_connections: 0
                  plugin: mysql_native_password
   authentication_string: *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9
        password_expired: N
   password_last_changed: 2024-04-30 11:30:33
       password_lifetime: NULL
          account_locked: N
        Create_role_priv: Y
          Drop_role_priv: Y
  Password_reuse_history: NULL
     Password_reuse_time: NULL
Password_require_current: NULL
         User_attributes: NULL
1 row in set (0.00 sec)
```

授权信息：

```
Select_priv：确定用户是否可以通过SELECT命令选择数据 
Insert_priv：确定用户是否可以通过INSERT命令插入数据 
Update_priv：确定用户是否可以通过UPDATE命令修改现有数据 
Delete_priv：确定用户是否可以通过DELETE命令删除现有数据 
Create_priv：确定用户是否可以创建新的数据库和表 
Drop_priv：确定用户是否可以删除现有数据库和表 
Reload_priv：确定用户是否可以执行刷新和重新加载MySQL所用各种内部缓存的特定命令，包括日志、权限、主机、查询和表 
Shutdown_priv：确定用户是否可以关闭MySQL服务器，将此权限提供给root账户之外的任何用户时，都应当非常谨慎 
Process_priv：确定用户是否可以通过SHOW 
File_priv：确定用户是否可以执行SELECT INTO OUTFILE和LOAD DATA INFILE命令 
Grant_priv：确定用户是否可以将已经授予给该用户自己的权限再授予其他用户，例如，如果用户可以插入、选择和删除foo数据库中的信息，并且授予了GRANT权限，则该用户就可以将其任何或全部权限授予系统中的任何其他用户 
References_priv：目前只是某些未来功能的占位符，现在没有作用 
Index_priv：确定用户是否可以创建和删除表索引 
Alter_priv：确定用户是否可以重命名和修改表结构 
Show_db_priv：确定用户是否可以查看服务器上所有数据库的名字，包括用户拥有足够访问权限的数据库，可以考虑对所有用户禁用这个权限，除非有特别不可抗拒的原因 
Super_priv：确定用户是否可以执行某些强大的管理功能，例如通过KILL命令删除用户进程，使用SET GLOBAL修改全局MySQL变量，执行关于复制和日志的各种命令 
Create_tmp_table_priv：确定用户是否可以创建临时表 
Lock_tables_priv：确定用户是否可以使用LOCK 
Execute_priv：确定用户是否可以执行存储过程，此权限只在MySQL 5.0及更高版本中有意义 
Repl_slave_priv：确定用户是否可以读取用于维护复制数据库环境的二进制日志文件，此用户位于主系统中，有利于主机和客户机之间的通信 
Repl_client_priv：确定用户是否可以确定复制从服务器和主服务器的位置 
Create_view_priv：确定用户是否可以创建视图，此权限只在MySQL 5.0及更高版本中有意义 
Show_view_priv：确定用户是否可以查看视图或了解视图如何执行，此权限只在MySQL 5.0及更高版本中有意义
Create_routine_priv：确定用户是否可以更改或放弃存储过程和函数，此权限是在MySQL 5.0中引入的
Alter_routine_priv：确定用户是否可以修改或删除存储函数及函数，此权限是在MySQL 5.0中引入的 Create_user_priv：确定用户是否可以执行CREATE 
Event_priv：确定用户能否创建、修改和删除事件，这个权限是MySQL 5.1.6新增的 
Trigger_priv：确定用户能否创建和删除触发器，这个权限是MySQL 5.1.6新增的
Create_tablespace_priv: 创建表的空间
```

## 权限列表
| 权限               | 权限级别         | 权限说明                                                                 |
|--------------------|------------------|--------------------------------------------------------------------------|
| CREATE             | 数据库、表或索引  | 创建数据库、表或索引权限                                                 |
| DROP               | 数据库或表       | 删除数据库或表权限                                                       |
| GRANT OPTION       | 数据库、表或保存的程序 | 赋予权限选项                                                             |
| REFERENCES         | 数据库或表       | 参考权限                                                                 |
| ALTER              | 表               | 更改表，比如添加字段、索引等                                             |
| DELETE             | 表               | 删除数据权限                                                             |
| INDEX              | 表               | 索引权限                                                                 |
| INSERT             | 表               | 插入权限                                                                 |
| SELECT             | 表               | 查询权限                                                                 |
| UPDATE             | 表               | 更新权限                                                                 |
| CREATE VIEW        | 视图             | 创建视图权限                                                             |
| SHOW VIEW          | 视图             | 查看视图权限                                                             |
| ALTER ROUTINE      | 存储过程         | 更改存储过程权限                                                         |
| CREATE ROUTINE     | 存储过程         | 创建存储过程权限                                                         |
| EXECUTE            | 存储过程         | 执行存储过程权限                                                         |
| FILE               | 服务器主机上的文件访问 | 文件访问权限                                                             |
| CREATE TEMPORARY TABLES | 服务器管理   | 创建临时表权限                                                           |
| LOCK TABLES        | 服务器管理       | 锁表权限                                                                 |
| CREATE USER        | 服务器管理       | 创建用户权限                                                             |
| PROCESS            | 服务器管理       | 查看进程权限                                                             |
| RELOAD             | 服务器管理       | 执行flush-hosts, flush-logs, flush-privileges, flush-status, flush-tables, flush-threads, refresh, reload等命令的权限 |
| REPLICATION CLIENT | 服务器管理       | 复制权限                                                                 |
| REPLICATION SLAVE  | 服务器管理       | 复制权限                                                                 |
| SHOW DATABASES     | 服务器管理       | 查看数据库权限                                                           |
| SHUTDOWN           | 服务器管理       | 关闭数据库权限                                                           |
| SUPER              | 服务器管理       | 执行kill线程权限                                                         |

## 用户授权

> `FLUSH PRIVILEGES;`

```sql
GRANT
  [权限] 
ON [库.表] 
TO [用户名]@[IP] 
IDENTIFIED BY [密码] 
# WITH GRANT OPTION;
```

> GRANT命令说明：
>
> - `ALL PRIVILEGES`：表示所有权限，你也可以使用select、update等权限
> - `ON`：用来指定权限针对哪些库和表
> - `*.*`：中前面的*号用来指定数据库名，后面的*号用来指定表名
> - `TO`：表示将权限赋予某个用户
> - `@`：前面表示用户，@后面接限制的主机，可以是IP、IP段、域名以及%，%表示任何地方
> - `IDENTIFIED BY`：指定用户的登录密码
> - `WITH GRANT OPTION`：这个选项表示该用户可以将自己拥有的权限授权给别人

**单个数据库单个表授权**

```sql
GRANT
  select
ON ctrip.t_plane
TO ctrip@'175.155.59.133'
IDENTIFIED BY 'ctrip';
```

**单个数据库单个表授权某些字段授权**

```sql
GRANT
  select(id,EN)
ON ctrip.t_plane
TO ctrip@'175.155.59.133'
IDENTIFIED BY 'ctrip';
```

## 收回权限

```sql
REVOKE
  [权限] 
ON [库.表] 
FROM [用户名]@[IP];
```

> 示例使用：
>
> ```sql
> REVOKE
>   select(id,EN)
> ON ctrip.t_plane
> FROM ctrip@'175.155.59.133';
> ```

## 删除用户

```sql
DROP USER [用户名]@[IP];
```

> 示例使用：
>
> ```
> DROP USER ctrip@'175.155.59.133';
> ```