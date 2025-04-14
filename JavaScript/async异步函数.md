# async异步函数

- `async`关键字用于声明一个异步函数，函数会返回一个Promise对象。如果函数返回一个非Promise值，该值会自动包装成一个Promise对象，如果函数没有返回值，那么它将返回一个隐式的`undefined`，这个`undefined`会被包装成一个Promise
- `await`操作符用于等待一个Promise解析（resolve）或拒绝（reject）。它只能在异步函数内部使用。当`await`操作符后的Promise解析时，它会返回解析的值。如果Promise被拒绝，`await`会抛出拒绝的值

## async示例代码

定义一个`async`函数后，可以通过几种方式使用它：

- 直接调用并处理返回的Promise
- 在另一个`async`函数内部使用`await`来等待它完成

```js
    // 定义一个async函数
    async function myAsyncFunction() {
      return "Hello, World!";
    }

    // 直接调用async函数并处理返回的Promise
    myAsyncFunction().then((message) => {
      console.log(message); // 输出: "Hello, World!"
    }).catch((error) => {
      console.error('There was an error:', error);
    });

    // 在另一个async函数内部使用await来等待myAsyncFunction完成
    async function useMyAsyncFunction() {
      try {
        let message = await myAsyncFunction();
        console.log(message); // 输出: "Hello, World!"
      } catch (error) {
        console.error('There was an error:', error);
      }
    }

    // 调用useMyAsyncFunction
    useMyAsyncFunction();
```

## 结合await使用

`await`操作符用于等待一个Promise解析（resolve）或拒绝（reject）。它只能在异步函数内部使用。当`await`操作符后的Promise解析时，它会返回解析的值。如果Promise被拒绝，`await`会抛出拒绝的值

```js
    async function fetchData() {
      let data = await fetch('https://api.example.com/data'); // fetch返回一个Promise
      let json = await data.json(); // data.json()也返回一个Promise，需要等待解析完成
      console.log(json);
    }
```

