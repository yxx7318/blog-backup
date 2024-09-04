# MP分页接口

```java
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.jkqcyl.exception.IllegalClassityException;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public interface CommonPageRequest<P> {
    /**
     * 封装mp分页查询方法(可变参数传递为mp的QueryWrapper的方法名可)
     * @param classity 前端传来的查询条件
     * @param mapper 执行查询的mapper
     * @return
     */
    default IPage<P> pageRequest(Map<String, String> classity, BaseMapper<P> mapper) {
        int pageNo, pageSize;
        if (classity.containsKey("pageNo")) {
            pageNo = Integer.parseInt(classity.remove("pageNo"));
        }else {
            pageNo = 1;
        }
        if (classity.containsKey("pageSize")) {
            pageSize = Integer.parseInt(classity.remove("pageSize"));
        }else {
            pageSize = 10;
        }

        QueryWrapper<P> queryWrapper = new QueryWrapper<>();
        for (String key : classity.keySet()) {
            if (containsSqlInjection(key) || containsSqlInjection(classity.get(key))) {
                throw new IllegalClassityException();
            }
            queryWrapper.eq(key, classity.get(key));
        }

        Page<P> page = new Page<>(pageNo, pageSize);
        IPage<P> iPage = mapper.selectPage(page, queryWrapper);

        return iPage;
    }

    default IPage<P> pageRequest(Map<String, String> classity, BaseMapper<P> mapper, QueryWrapper<P> conditions) {
        int pageNo, pageSize;
        if (classity.containsKey("pageNo")) {
            pageNo = Integer.parseInt(classity.remove("pageNo"));
        }else {
            pageNo = 1;
        }
        if (classity.containsKey("pageSize")) {
            pageSize = Integer.parseInt(classity.remove("pageSize"));
        }else {
            pageSize = 10;
        }

        QueryWrapper<P> queryWrapper = conditions;
        for (String key : classity.keySet()) {
            if (containsSqlInjection(key) || containsSqlInjection(classity.get(key))) {
                throw new IllegalClassityException();
            }
            queryWrapper.eq(key, classity.get(key));
        }

        Page<P> page = new Page<>(pageNo, pageSize);
        IPage<P> iPage = mapper.selectPage(page, queryWrapper);

        return iPage;
    }

    /**
     * 是否含有sql注入，返回true表示含有
     *
     * @param obj
     * @return
     */
    default boolean containsSqlInjection(Object obj) {
        Pattern pattern = Pattern.compile(
                "\\b(and|exec|insert|select|drop|grant|alter|delete|update|count|chr|mid|master|truncate|char|declare|or)\\b|(\\*|;|\\+|'|%)");
        Matcher matcher = pattern.matcher(obj.toString());
        return matcher.find();
    }
}
```

