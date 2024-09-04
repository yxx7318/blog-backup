# Spring Boot注解

## 基础注解

- `@Configuration`：用于类上，将类标识为配置类，**主要目的是作为bean定义的源**(属性`proxyBeanMethods`为false时**标识类中的`@Bean`将采用"多例"**——启动代理就是会在启动时创建bean放入IOC容器(适用类中有依赖关系)，关闭代理后就只有使用时会创建bean，每次创建的都不同)
  - Lite模式：配置类组件之间无依赖关系，加速容器启动过程，减少判断
  - Full模式：配置类组件之间有依赖关系，方法会被调用得到之前的单实例组件
  
- `@Bean`：用于在添加了`@Configuration`类中的方法上，将方法返回的对象注入IOC容器中(默认为方法名，`value`属性设置别名)，**一般用于注入无法添加`@component`的jar包中的第三方bean**。方法中如果需要使用IOC容器中的bean，只需要在方法的参数中声明为形参即可，容器会自动装配，在方法体中就可以使用此bean中的方法

- `@Import({xxx.class,yyy.class})`：用于类上，容器中自动创建调用这两个组件的无参构造器，创造出指定的这些组件类型的对象，**把普通的类定义为bean**，还可以引入一个`@Configuration`修饰的类(引入配置类)，从而把让配置类生效(**配置类下的所有bean添加到IOC容器里面去**)

- `@Conditional(name = "xxx")`：用于类或者方法上，条件装配，当容器中有名称为"xxx"的bean才进行装配，(或者可以是xxx.class也可以，还有更多的衍生注解可以判断使用——`@ConditionalOnMissingBean`：当不存在此bean时)

- `@ImportResource("classpath:xxx.xml")`：用于类上，**可以直接导入Spring的配置文件**，并让它进行生效

- `@ConfigurationProperties(prefix = "xxx")`：用于bean类上，将properties文件或者yaml(**application.properties的优先级最高，yml其次，yaml最低**)里面的数据读取出来并为bean里面的属性赋值(prefix为前缀)，再使用`@Component`将bean放入IOC容器，也可以在配置类上使用`@EnableConfigurationProperties(xxx.class)`将已经注入值的bean放入IOC容器

- `@Lazy`：用于类上，**用于延迟初始化**，延迟到第一次使用时才会注入IOC容器

- `@Scope`：用于类上，**设置bean的作用域**(默认为单例`singleton`，可设置为多例`prototype`，web下还有三种作用域`request`，`session`，`application`)

- `@PostConstruct`：用于**在依赖注入完成后**执行某些初始化方法，这个注解标注的方法会在bean的所有依赖项都已经被注入之后，且在任何生命周期回调方法（例如`@Autowired`，`@Value`等）之前被调用。这个注解对应的方法没有参数，返回类型为void，且只能有一个这样的方法

- `@PreDestroy`：用于**在bean被移除之前**执行某些销毁方法，这个注解标注的方法会在bean被移除之前被调用，例如在Spring容器关闭时。这个注解对应的方法没有参数，返回类型为void，且只能有一个这样的方法

- `@JsonFormat`：用于属性上，**用于指定日期、时间或数字等类型的格式化方式**的注解，通常用于在将Java对象转换为JSON字符串时，对日期、时间等格式进行定制化(`@JsonValue`指定值作为整个对象的JSON表示)

  - `pattern`：指定日期、时间的格式，例如`"yyyy-MM-dd HH:mm:ss"`
  
    - ```java
          // 指定后端返回的格式，为"yyyy-MM-dd HH:mm:ss"，时区为GMT+8
          @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
          private Date createTime;
      ```

  - `shape`：指定日期、时间的序列化形式，有以下几种取值：

    - `JsonFormat.Shape.STRING`：以字符串形式序列化
  
      - 设置数字类型的格式化方式，转化为字符串，解决前端精度问题
  
        - ```java
              // 指定MVC在序列化为JSON时将该字段转化为String类型
              @JsonFormat(shape = JsonFormat.Shape.STRING)
              private Long id;
          ```
  
    - `JsonFormat.Shape.NUMBER`：以数字形式序列化
  
    - `JsonFormat.Shape.ARRAY`：以数组形式序列化
  
    - `JsonFormat.Shape.OBJECT`：以对象形式序列化
  
  - `locale`：指定地区信息，用于格式化日期、时间
  
  - `timezone`：指定时区信息，用于格式化日期、时间
  
- `@DateTimeFormat`：用于属性上，将**接收的字符串转换为日期**(只有**字符串符合指定格式**时才会进行转换)，有`pattern` 和 `iso` 属性，两者一起使用时，`pattern` 属性会覆盖 `iso` 属性。对于指定的情况不符合时会使用默认的SpringMVC字符串处理方式

  - `pattern`：指定日期、时间的格式(对于同时存在日期和时间的，**字符串中需要通过T来分隔**)有以下几种取值：

    - `"yyyy-MM-dd"`：代表年-月-日

    - `"yyyy/MM/dd"`：代表年/月/日

    - `"yyyy-MM-dd HH:mm:ss"`：代表年-月-日 时:分:秒

      - ```java
            // 指定接收前端字符串的格式
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
            private Date date;
        ```

    - `"yyyy-MM-dd'T'HH:mm:ss"`：代表年-月-日THH:mm:ss（ISO 8601格式）

  - `iso`：指定日期、时间的ISO格式，有以下几种取值：

    - `DateTimeFormat.ISO.DATE`：相当于 "yyyy-MM-dd" 格式。这表示只包括年、月和日的部分，不包括时间部分

      - ```java
            // 日期可以使用ISO日期格式，如果想要包含时间，可以使用DateTimeFormat.ISO.DATE_TIME
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            private Date date;
        ```

    - `DateTimeFormat.ISO.DATE_TIME`：指定的是日期和时间的完整格式，即`"yyyy-MM-dd'T'HH:mm:ss.SSSX"`。这个格式包括年、月、日、时、分、秒以及毫秒，并且还考虑了时区信息("X"为时区信息，它会形如"+08:00"表示东八区)

> 对于代码，在接收前端数据时，Spring框架会报错，因为两者不一致(但是只用于后端数据返回就不会)
>
> ```java
>     @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss",timezone="GMT+8")
>     @DateTimeFormat(pattern = "yyyy-MM-dd")
>     private Date visitorDate;
> ```
>
> 应该修改为，保持一致
>
> ```java
>     @JsonFormat(pattern = "yyyy-MM-dd",timezone="GMT+8")
>     @DateTimeFormat(pattern = "yyyy-MM-dd")
>     private Date visitorDate;
> ```

- `@JsonValue`：用于指定一个方法或字段，其值将作为整个对象的JSON表示。当对象被序列化为JSON时，只有被`@JsonValue`注解标记的方法或字段的值会被包含在内，而不是整个对象的所有属性

## 整合衍生注解

JUnit

- `@SpringBootTest(classes = xxx.class)`：用于类上，将类标识为一个测试类，并引入指定的配置类
  - `@ContextConfiguration(locations = "classpath:xxx.xml" / classes = yyy.class)`：用于测试类上，用于引入指定的配置类

MyBatis

- `@Mapper`：用于类上，给mapper接口自动生成一个实现类，让Spring对mapper接口的bean进行管理，并且可以省略去写复杂的xml文件
  - `@Insert`：用于方法上，等同于Mapper.xml中的`<insert>`
  - `@Delete`：用于方法上，等同于Mapper.xml中的`<delete>`
  - `@Update`：用于方法上，等同于Mapper.xml中的`<update>`
  - `@Select`：用于方法上，等同于Mapper.xml中的`<select>`

MyBatisPlus

- `@TableName("xxx")`：用于bean上，设置bean的映射表名
  - `@TableId(type = IdType.AUTO)`：用于属性上，设置为主键且是自增的，确保在进行添加时不会出错
  - `@TableField("xxx")`：用于属性上，设置属性和字段的映射关系

## 关于classpath和classpath*

- classpath：只指定此模板/项目下的class路径
- classpath*：不仅包含此项目下的class路径，还会在项目打包后jar包中的class路径中去找

使用示例：

```yaml
# MyBatis Plus配置
mybatis-plus:
  # 搜索指定包别名(生效范围在项目打包后jar包下)
  typeAliasesPackage: org.hnxxxy.rg1b.domain,org.hnxxxy.rg1b.**.domain
  # 配置mapper的扫描，找到所有的mapper.xml映射文件
  mapperLocations: classpath*:mapper/**/*Mapper.xml
  # 加载全局的配置文件
  configLocation: classpath:mybatis/mybatis-config.xml
```

## dev-tools

```xml
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-devtools</artifactId>
        <!-- 防止将依赖传递到其他模块中 -->
		<optional>true</optional>
		<!-- 只在运行时起作用，打包时不打进去（防止线上执行打包后的程序，启动文件监听线程File Watcher，耗费大量的内存资源） -->
        <scope>runtime</scope>
	</dependency>
```

通过 Ctrl ＋ F9 实现热部署，不用再重新加载和部署第三方的jar包，减少资源消耗和等待时间

有可能会出现无法生效的问题，此时需要在`<plugin>`中配置

```xml
                <configuration>
                    <fork>true</fork> <!-- 如果没有该配置，devtools不会生效 -->
                </configuration>
```

## 整合第三方

- 第一步：找第三方技术所对应的starter
- 第二步：做相应的配置
- 第三步：直接使用对应的技术进行开发
