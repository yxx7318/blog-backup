# TS的基本使用

TS相当于给JS套了一层类型系统，通过TS，可以进行代码的静态类型检查，这样就可以将类型错误暴露在运行之前

## 原始数据类型

```tsx
let isGreat: boolean = true
let examMark: number = 100
let fullName: string = "编程"
let u:undefined = undefined
let n: null = null
```

> 当变量类型指定后，就不能再赋值其它类型给变量

## 数组的类型

```tsx
// 如果使用不同类型的元素，可以使用"元组"(编译之后还是数组)
// 这个指定了元素的类型和位置都必须一致，必须赋值
let tuples01: [string, number] = ["编程", 1]
// push则只要是其中一种类型即可
tuples01.push(2)
// 不要求顺序
tuples01.push("测试", 3)
// [ '编程', 1, 2, '测试', 3 ]
console.log(tuples01)
```

## 限制变量的取值

```tsx
// 必须取其中的两个值
let gender: "male" | "female"
gender = "female"
```

## 接口

> 定义数据的形状，定义对象包含哪些属性和方法
>
> - 属性：属性的类型
> - 方法：参数类型、返回值类型

属性

```tsx
// 定义接口
interface IPerson {
    // 规定属性只读，初始化后不可修改
    readonly id: number;
    name: string;
    // ?代表属性可选
    age?: number
}

let person: IPerson = {
    id: 1,
    name: "yu"
}
```

方法

```tsx
// ?设置参数可传可不传，函数必选参数必须要使用，且可选参数必须在必选参数之后
// 使用?后，不加检测变量的类型，不能直接使用，会报错
function sum(x: number, y?: number, z?: number): number {
    if (y == undefined) {
        return x
    }
    return x + y
}

sum(1, 10)

// 限定方法的参数类型和返回值
interface ISumStr {
    (a: string, b: string): string
}

let sumStr: ISumStr = (a, b) => {
    return a + b
}

// 限定回调函数
let myCallback = function(callback : (a: string, b: string) => string) {
    console.log("定义回调函数成功")
    return callback
}

// 获取回调函数的函数对象
let result = myCallback((a: string, b: string) => a + b)
// 定义回调函数成功
// 你好
console.log(result("你", "好"))
```

> void指定返回值为空

## 联合类型

```tsx
// 定义可为数字或者字符串
let numberOrString: number | string;
numberOrString = 100
numberOrString = "字符"
```

### 类型断言

```tsx
// 将变量强制定义为联合类型中的一种
let c = numberOrString as string
c.length
```

## 复杂对象

### 枚举定义

```tsx
// 枚举成员会被赋值为递增的数字(enum Icon {circleCheck, warning})(从0开始)，通过"="显式地指定值
enum Icon {
  circleCheck = CircleCheck,
  warning = Warning,
  circleClose = CircleClose
}

enum Status {
  wait = 'wait',
  process = 'process',
  finish = 'finish',
  error = 'error',
  success = 'success'
}
```

### 对象定义

```tsx
interface Step {
  title: string,
  icon: Icon,
  description: string,
  date: string,
  status: Status
}
```

## 泛型

```tsx
// 返回形参的交换结果
function swap<T, U>(arr: [T, U]): [U, T] {
    return [arr[1], arr[0]]
}
// [ '编程', 100 ]
console.log(swap([100, "编程"]))
```

### 泛型约束

```tsx
// 定义数据的形状，必须有length属性
interface IWithLength {
    length: number
}

// 对泛型进行约束
function returnLength<T extends IWithLength>(arg: T): number {
    return arg.length
}

returnLength("编程")
returnLength(["Python", "JavaScript", "Java"])
returnLength({length: 100})
// returnLength(100)，数字没有长度，报错
```

## 类型别名

```tsx
// 给类型范围取一个别名
type UserId = number | string
let id: UserId = 1
```
