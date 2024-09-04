# SSM注解

MyBatis

- `@Param("key")`：用于形参内，**标识形参value作为MyBatis的键值对**，通过`#{key}`获取值

Spring

- `@Component("id")`：用于类上，将类标识为普通组件(**value属性设置类的id和name**)
  - `@Controller`：将类标识为控制层组件
  - `@Service`：将类标识为业务层组件
  - `@Repository`：将类标识为持久层组件

- `@Autowired`：用于属性上，**优先按byType自动装配属性**(required默认为true，表示一定要完成装配)

- `@Resource`：用于属性上，**优先按byName自动装配属性**(name指定装配的属性名称，type指定装配的属性类型)

- `@Aspect`：用于类上，标识为一个切面类
  - `@Pointcut("execution(* com.atguigu.spring.proxy.CalculatorImpl.*(..))")`：切入点表达式
  - `@Before("testPointCut()")`：前置通知(**JoinPoint joinPoint**)
  - `@AfterReturning(value = "testPointCut()",returning = "result")`：返回通知(**通过result调用结果**)
  - `@AfterThrowing(value = "testPointCut()",throwing = "ex")`：异常通知
  - `@Around("testPointCut()")`：环绕通知，用于方法上，通过**try...catch...finally**标识通知(**ProceedingJoinPoint proceedingJoinPoint**)(**通过return返回值**)

- `@RunWith(SpringJUnit4ClassRunner.class)`：用于类上，设置当前测试类的运行环境，在spring的测试环境中运行，就可以通过注入的方式直接获取IOC容器中的bean
- `@ContextConfiguration("classpath:spring-tx-annotation.xml")`：用于类上，设置Spring测试环境的配置文件

- `@Transactional`：用于方法或者类上，**让方法体内的操作视为同一个事务**

- `@ControllerAdvice{annotations = {xxx.class}}`：用于类上，**将当前类标识为异常处理的组件**，监听添加了指定注解的类
  - `@ExceptionHandler({xxx.class})`：**用于设置方法需要处理的异常**
- `@RestControllerAdvice`：用于类上，是 `@ControllerAdvice` 和 `@ResponseBody` 的组合，默认会对所有的 `@Controller` 注解的类进行增强(包括`@RestController`)


SpringMVC

- `@RequestMapping`：用于方法或者类上，类和方法最终组合的结果就是浏览器访问对应地址所对应的控制层方法
  - `@GetMapping`：处理get请求的映射
  - `@PostMapping`：处理post请求的映射
  - `@PutMapping`：处理put请求的映射
  - `@DeleteMapping`：处理delete请求的映射

- `@RequestParam("key")`：用于形参内，**将发送参数的值与形参匹配**

- `@RequestHeader`：用于形参内，获取请求头信息
- `@RequestBody`：用于形参内，**结合JSON解析器，接收前端传过来的JSON格式对象绑定到对象中**
- `@ResponseBody`：用于方法和类上，标识在类上时，表示该类中所有的方法均应用，**可以将方法返回的数据转化为JSON格式(不会进行页面跳转)**
- `@RestController`：用于类上，是`@ResponseBody`和`@Controller`的结合
- `@CookieValue`：用于形参内，获取cookie数据
- `@PathVariable`：用于形参内，**将形参名与REST风格数据相匹配**
- `@ControllerAdvice`：用于类上，将当前类标识为异常处理的组件

- `@Configuration`：用于类上，**将类标识为配置类，主要目的是作为bean定义的源**
- `@ComponentScan("com.atguigu.SpringMVC")`：用于类上，扫描组件
- `@EnableWebMvc`：用于类上，开启mvc注解驱动
- `@Bean`：用于方法上，**将标识的方法的返回值作为bean进行管理**，bean的id为方法的方法名
- `@CrossOrigin(origins = "*")`：用于方法或者类上，给响应体添加跨域请求头，`Access-Control-Allow-Origin`、`Access-Control-Allow-Methods`、`Access-Control-Allow-Headers`等头部信息