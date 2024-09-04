# MP接口增强

## 基本增强

> 通过实现MP的`IService`接口，并对方法进行一定的增强可以增加属于自己的通用方法

IdInterface.java

```java
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;

import java.lang.reflect.Field;

public interface IdInterface<T> extends IService<T> {

    /**
     * 获取id的名字
     *
     * @param t 具有@TableId注解的entity对象
     * @return id的名字
     */
    default String getIdName(T t) {
        Class<?> aClass = t.getClass();
        String resultName = "id";
        // 反射获取属性名称，自动映射
        for (Field field : aClass.getDeclaredFields()) {
            if (!ObjectUtils.isEmpty(field.getAnnotation(TableId.class))) {
                resultName = field.getName();
                break;
            }
        }
        return resultName;
    }

    /**
     * 获取id的字段名
     *
     * @param t 具有@TableId注解的entity对象
     * @return id的字段名字
     */
    default String getIdColumnName(T t) {
        Class<?> aClass = t.getClass();
        String resultName = "id";
        // 反射获取属性名称，自动映射
        for (Field field : aClass.getDeclaredFields()) {
            TableId annotation = field.getAnnotation(TableId.class);
            if (!ObjectUtils.isEmpty(annotation)) {
                if (!StringUtils.isEmpty(annotation.value())) {
                    resultName = annotation.value();
                } else {
                    resultName = field.getName().replace("Id", "_id");
                }
                break;
            }
        }
        return resultName;
    }

    /**
     * 获取id的值
     *
     * @param t      具有@TableId注解的entity对象
     * @param idName id的名字
     * @return id的值
     */
    default Long getIdValue(T t, String idName) {
        try {
            Field currentField = t.getClass().getDeclaredField(idName);
            currentField.setAccessible(true);
            return currentField.get(t) != null ? (Long) currentField.get(t) : null;
        } catch (NoSuchFieldException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
    }
}
```

## 结合泛型

MpPlus.java

```java
import com.cebc.common.exception.UniappException;
import com.cebc.uniapp.domain.UniappBaseEntity;
import org.springframework.util.ObjectUtils;


public interface MpPlus<T extends UniappBaseEntity> extends IdInterface<T> {

    /**
     * 执行更新获取插入
     *
     * @param t 继承ExamineBaseVo的对象
     * @return 受影响行数
     */
    default Long updateOrInsert(T t) {
        // 获取id的值，确定是进行插入还是更新
        String idName = getIdName(t);
        Long idValue = getIdValue(t, idName);
        if (ObjectUtils.isEmpty(idValue)) {
            this.getBaseMapper().insert(t);
            // 重新获取值，因为id会自增返回到主键上
            return getIdValue(t, idName);
        }
        // 此时id值不为空，应该执行更新操作
        T tempOne = this.getBaseMapper().selectById(t);
        if (ObjectUtils.isEmpty(tempOne)) {
            throw new UniappException("id未知：" + idName);
        }
        // 可以获取UniappBaseEntity对象的方法
        t.setRemark("执行了更新操作");
        return (long) this.getBaseMapper().updateById(t);
    }
}
```

