# JSP

## JSP四大作用域

|    名称     |        作用域        |
| :---------: | :------------------: |
|    page     |    在当前页面有效    |
|   request   |   在当前请求中有效   |
|   session   |   在当前会话中有效   |
| application | 在所有应用程序中有效 |

- 页面域（page scope）:页面域的生命周期是指**页面执行期间**。离开当前的JSP页面，属性值会消失。
- 请求域（request scope）：请求域的生命周期是指**一次请求的过程**。页面通过**forword方式**跳转，目标页面仍然可以获得request的属性值。如果通过**sendRedirect方式**进行页面跳转，会去重新访问新的指定的URL地址，request的属性值会丢失。
- 会话域（session scope）：会话域的生命周期是指**某个客户端与服务器所连接**的时间，会话过期或用户自动退出后，会话失效。存储在会话域中的对象在整个会话期间都可以被访问。
- 应用域（application scope）:应用域的生命周期是指从**服务器开始执行到服务器关闭**为止，是4个作用域时间最长的。 存储在应用域中的对象在整个应用程序运行期间可以被所有JSP和Servlet共享访问。

定义：

```jsp
<%
    pageContext.setAttribute("info", "page属性范围");
    request.setAttribute("info", "request属性范围");
    session.setAttribute("info", "session属性范围");
    application.setAttribute("info", "application属性范围");
%><!--这里写在jsp里面的，对于servlet类只继承了request-->
	<c:set var="info" value="session属性范围" scope="session"/>
```

取出：

```jsp
<%
    session.getAttribute("info");//同样servlet类受范围影响
%>
	${sessionScope.info}
```

如果是在servlet类中设置和取出session作用域的数据，则需要使用**HttpSession**类中的方法，定义和取出：

```java
	//获取HttpSession对象
	HttpSession session = request.getSession();
	//设置值或取出值
	session.setAttribute("key",value);//取出为对应的get方法
```

