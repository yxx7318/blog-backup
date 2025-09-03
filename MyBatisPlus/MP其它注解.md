# MP其它注解

## @InterceptorIgnore

> 用于**排除特定拦截器**对某个Mapper方法的影响，让指定方法绕过MyBatis-Plus的某些自动拦截逻辑

使用方式：

```java
@InterceptorIgnore(tenantLine = "true", illegalSql = "true")
public interface UserMapper extends BaseMapper<User> {
    // 这个方法将忽略租户拦截器和SQL检查拦截器
    @Select("SELECT * FROM user WHERE age > #{age}")
    List<User> selectByAge(@Param("age") int age);
}
```

参数说明：

| 参数               | 说明                        | 默认值  |
| :----------------- | :-------------------------- | :------ |
| `tenantLine`       | 是否忽略租户拦截器          | "false" |
| `dynamicTableName` | 是否忽略动态表名拦截器      | "false" |
| `illegalSql`       | 是否忽略SQL注入检查拦截器   | "false" |
| `blockAttack`      | 是否忽略全表更新/删除拦截器 | "false" |
| `dataPermission`   | 是否忽略数据权限拦截器      | "false" |

## @KeySequence

> 用于**指定数据库序列生成器**，主要用于Oracle、PostgreSQL等支持序列的数据库

使用方式：

```java
@KeySequence(value = "seq_user", clazz = Long.class)
public class User {
    @TableId(type = IdType.INPUT)
    private Long id;
    // 其他字段...
}
```

参数说明：

| 参数     | 说明           | 必填 |
| :------- | :------------- | :--- |
| `value`  | 数据库序列名称 | 是   |
| `clazz`  | 主键类型       | 是   |
| `dbType` | 数据库类型     | 否   |

## @OrderBy

> 在实体类字段上**指定默认排序规则**，查询时会自动添加ORDER BY子句

使用方式：

```java
public class User {
    @OrderBy // 默认升序
    private LocalDateTime createTime;
    
    @OrderBy(asc = false) // 指定降序
    private Integer score;
}
```

> - **全局生效**：影响所有查询该实体的操作
> - **多字段支持**：可在多个字段上使用
> - **优先级低于Wrapper**：如果使用QueryWrapper指定了排序，会覆盖此注解