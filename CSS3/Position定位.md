# Position定位

## absolute

> 可以使用absolute去实现覆盖在Flex布局上面
>
> - 绝对定位的元素会脱离文档流，这意味着它不会影响其他元素的布局，也不受其他元素的影响
> - 可以使用`top`、`bottom`、`left`、`right`来精确控制元素的位置，并且`z-index`可以用来控制层叠上下文

距离顶部`720px`，覆盖在Flex上面：

```css
style="position:absolute;top:270px;width:100%"
```

> ![image-20241216202552903](img/Position定位/image-20241216202552903.png)
