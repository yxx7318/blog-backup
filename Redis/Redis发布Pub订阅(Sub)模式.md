# Redis发布Pub订阅(Sub)模式

> 发布/订阅模式是一种消息范式，它允许发送者（发布者）向某个频道发送消息，而不必指定具体的接收者。相反，接收者（订阅者）通过订阅特定频道来接收消息。这种方式解耦了消息的生产者和消费者，使得系统更加灵活、可扩展

## 基本命令

### SUBSCRIBE

> 功能：订阅给定的一个或多个频道。一旦订阅成功，客户端会进入订阅状态，在此状态下不能执行除订阅相关命令外的其他命令
>
> 格式：`SUBSCRIBE channel [channel ...]`

订阅`news`和`announcements`频道参考命令：

```
SUBSCRIBE news announcements
```

### UNSUBSCRIBE

> 当一个客户端不再需要接收某些频道上的消息时，可以使用`UNSUBSCRIBE`命令来取消订阅，如果没有指定频道，则默认取消订阅所有频道；如果有指定，则只取消订阅指定的频道

取消订阅`news`频道：

```
UNSUBSCRIBE news
```

取消订阅所有频道：

```
UNSUBSCRIBE
```

### 模式匹配

> 除了直接订阅具体的频道之外，Redis还支持通过模式匹配的方式进行订阅，即使用`PSUBSCRIBE`命令根据模式匹配来订阅频道

- `SUBSCRIBE`：订阅符合给定模式的所有频道。模式允许包含通配符，如`*`表示任意数量的字符，订阅所有以`.end`结尾的频道：

  - ```
    PSUBSCRIBE *.end
    ```

- `PUNSUBSCRIBE [pattern [pattern ...]]`：取消根据模式的订阅。如果没有提供模式，则取消所有模式订阅：

  - ```
    PUNSUBSCRIBE *.end
    
    PUNSUBSCRIBE
    ```

## 示例代码

pom.xml

```xml
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
```

RedisMessageListener.java

```java
import org.springframework.context.annotation.Scope;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.stereotype.Component;

/**
 * 自定义的消息监听器，用于处理接收到的Redis消息。
 */
@Component
@Scope("prototype")
public class RedisMessageListener implements MessageListener {

    /**
     * 当从Redis订阅的主题中接收到消息时调用此方法。一个对象也可以订阅多个频道，但是在取消订阅时所有频道就都被取消订阅了
     *
     * @param message 接收到的实际消息对象。可以通过调用message.getBody()来获取消息内容，
     *                而调用message.toString()则可以获取关于消息的更多信息，如频道等
     * @param pattern 订阅模式匹配的字节数组，如果使用的是模式匹配订阅（PSUBSCRIBE）而不是直接的主题订阅（SUBSCRIBE）
     *                对于直接的主题订阅，这个值通常是null
     */
    @Override
    public void onMessage(Message message, byte[] pattern) {
        // 打印接收到的消息内容
        System.out.println("Received message: " + new String(message.getBody()) + "; Topic：" + new String(pattern));
    }
}
```

RedisPubSubUtil.java

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class RedisPubSubUtil {

    private final StringRedisTemplate redisTemplate;
    private final RedisMessageListenerContainer listenerContainer;
    private final Map<String, MessageListener> listeners = new HashMap<>();

    @Autowired
    public RedisPubSubUtil(StringRedisTemplate redisTemplate, RedisMessageListenerContainer listenerContainer) {
        this.redisTemplate = redisTemplate;
        this.listenerContainer = listenerContainer;
    }

    /**
     * 发布消息到指定主题
     *
     * @param topic   消息将被发送到的主题名称
     * @param message 要发布的消息内容
     */
    public void publish(String topic, String message) {
        redisTemplate.convertAndSend(topic, message);
    }

    /**
     * 订阅某个主题的消息
     *
     * @param listener 实现了MessageListener接口的对象，用于定义如何处理接收到的消息
     * @param topic    要订阅的主题名称
     */
    public String subscribe(MessageListener listener, String topic) {
        // 单次订阅
        listenerContainer.addMessageListener(listener, new ChannelTopic(topic));
        // 一个对象允许多次订阅(无法取消订阅)
//        listenerContainer.addMessageListener((message, pattern) -> listener.onMessage(message, pattern), new ChannelTopic(topic));
        listeners.put(topic, listener);
        return topic; // 返回订阅的topic作为订阅ID
    }

    /**
     * 取消订阅
     *
     * @param topic 要订阅的主题名称
     */
    public String unsubscribe(String topic) {
        MessageListener listener = listeners.remove(topic);
        if (listener != null) {
            listenerContainer.removeMessageListener(listener);
            return "Unsubscribed from " + topic;
        } else {
            return "No subscription found for " + topic;
        }
    }
}
```

RedisTestController.java

```java
import com.yxx.common.annotation.Anonymous;
import com.yxx.common.utils.spring.SpringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Anonymous
public class RedisTestController {

    @Autowired
    private RedisPubSubUtil redisPubSubUtil;

    // 使用工厂模式进行生成bean
    private RedisMessageListener getRedisMessageListener() {
        return SpringUtils.getBean(RedisMessageListener.class);
    }

    @GetMapping("/subscribe")
    public String subscribe(@RequestParam String topic) {
        return "Subscribed! " + redisPubSubUtil.subscribe(getRedisMessageListener(), topic);
    }

    @GetMapping("/publish")
    public String publish(@RequestParam String message, @RequestParam String topic) {
        redisPubSubUtil.publish(topic, message);
        return "Published! " + topic;
    }

    @GetMapping("/unsubscribe")
    public String unsubscribe(@RequestParam String topic) {
        return redisPubSubUtil.unsubscribe(topic);
    }
}
```

订阅消息：

```
http://localhost:8080/subscribe?topic=test
http://localhost:8080/subscribe?topic=test1
```

> 可以订阅多个频道

发送消息到频道：

```
http://localhost:8080/publish?message=Hello%20World&topic=test
http://localhost:8080/publish?message=Hello%20World&topic=test1
```

> ```
> Received message: Hello World; Topic：test
> Received message: Hello World; Topic：test1
> ```

取消订阅`test1`：

```
http://localhost:8080/unsubscribe?topic=test1
```

发送消息到频道`test1`：

```
http://localhost:8080/publish?message=Hello%20World&topic=test1
```

> 没有消息展示