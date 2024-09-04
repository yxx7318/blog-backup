# Mysql插入性能优化

## MyISAM引擎

- 禁用唯一性检查：为了在数据插入时提高性能，可以在插入记录之前禁用唯一性检查。在插入完成后，再将唯一性检查重新启用
  - 禁用唯一性检查：`SET UNIQUE_CHECKS=0;`
  - 启用唯一性检查：`SET UNIQUE_CHECKS=1;`
- 禁用外键检查：在插入大量数据之前，可以禁用外键检查以提高性能。在数据插入完成后，再恢复外键检查
  - 禁用外键检查：`SET global FOREIGN_KEY_CHECKS=0;`
  - 恢复外键检查：`SET FOREIGN_KEY_CHECKS=1;`
- 禁止自动提交：在插入数据之前禁止事务的自动提交，在数据导入完成后，执行恢复自动提交操作
  - 禁止自动提交：`SET AUTOCOMMIT=0;`
  - 恢复自动提交：`SET AUTOCOMMIT=1;`
- 配置`max_allowed_packet`：根据数据包大小，配置`max_allowed_packet`以允许更大的数据包，适用于大事务或批量插入操作`max_allowed_packet=1073741824;`
- 调整MyISAM存储引擎的I/O设置：
  - `key_buffer_size`：设置为内存的25%或适当大小，以减少磁盘I/O操作
  - `bulk_insert_buffer_size`：根据插入数据量调整，以减少磁盘I/O次数
  - `concurrent_insert`：设置为2，允许在表末尾并发插入数据
  - `delay_key_write`：设置为ALL，延迟键写入，直到表关闭或事务提交
- 调整MyISAM存储引擎的其他设置：
  - `tmp_table_size`：设置临时表的大小，以避免磁盘上的临时表
  - `max_heap_table_size`：设置最大堆表大小，同样用于避免磁盘上的临时表

修改`mysqld.cnf`，以服务器4G内存为例

```
[mysqld]
key_buffer_size = 1024M  # 根据内存大小调整
bulk_insert_buffer_size = 64M  # 根据插入数据量调整
concurrent_insert = 2  # 允许在表末尾并发插入
delay_key_write = ALL  # 延迟键写入，直到表关闭或事务提交
tmp_table_size = 64M  # 临时表大小
max_heap_table_size = 64M  # 最大堆表大小
```

## InnoDB引擎

- 禁用唯一性检查：为了在数据插入时提高性能，可以在插入记录之前禁用唯一性检查。在插入完成后，再将唯一性检查重新启用
  - 禁用唯一性检查：`SET UNIQUE_CHECKS=0;`
  - 启用唯一性检查：`SET UNIQUE_CHECKS=1;`
- 禁用外键检查：在插入大量数据之前，可以禁用外键检查以提高性能。在数据插入完成后，再恢复外键检查
  - 禁用外键检查：`SET global FOREIGN_KEY_CHECKS=0;`
  - 恢复外键检查：`SET FOREIGN_KEY_CHECKS=1;`
- 禁止自动提交：在插入数据之前禁止事务的自动提交，在数据导入完成后，执行恢复自动提交操作
  - 禁止自动提交：`SET AUTOCOMMIT=0;`
  - 恢复自动提交：`SET AUTOCOMMIT=1;`
- 禁止时时同步日志到磁盘：设置`innodb_flush_log_at_trx_commit`为2，以禁止事务提交时实时同步日志到磁盘`SET global innodb_flush_log_at_trx_commit=2;`
- 配置`max_allowed_packet`为1G：将max_allowed_packet配置为1G，以允许更大的数据包大小，适用于大事务或批量插入操作`max_allowed_packet=1073741824;`
- 调整InnoDB存储引擎的I/O和日志设置：
  - `innodb_io_capacity`：设置为2000
  - `innodb_io_capacity_max`：设置为20000
  - `innodb_flush_method`：设置为O_DIRECT
  - `innodb_autoextend_increment`：从默认的8M调整到128M，以减少表空间的自动扩展次数
  - `innodb_log_buffer_size`：从默认的1M调整到128M，以减少数据库写数据文件的次数
  - `innodb_log_file_size`：从默认的8M调整到128M，以减少数据库的checkpoint操作。

在`/etc/my.cnf`中进行以下修改：

```
[mysqld]
innodb_io_capacity = 2000
innodb_io_capacity_max = 20000
innodb_flush_method = O_DIRECT
innodb_autoextend_increment = 128
innodb_log_buffer_size = 128M
innodb_log_file_size = 128M
```