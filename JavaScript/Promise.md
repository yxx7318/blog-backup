# Promise

## 基本概念

> Promise是JavaScript中用于处理异步操作的对象。它表示一个尚未完成但预期将来会完成的操作的结果

Promise分为两个概念：

- Promise A+规范：为了解决回调地狱以及异步实现不统一的问题，Promise就是一个带有then方法的东西，可能是对象，也有可能是函数
- ES6里面的Promise：构造函数`new Promise()`，对Promise A+规范的实现，除了`.then`之外还加了`.catch`(可以被看作是只处理拒绝情况的`.then()`方法，它的作用是简化错误处理的语法。`promise.catch(onRejected)`等同于`promise.then(null, onRejected)`)

在很多第三方库里面，判断一个对象是不是Promise，就看它里面有没有包含`.then`

基本状态：

- **Pending（进行中）**：Promise刚创建时处于这个状态，未返回结果前，一直处于此状态
- **Fulfilled（已成功）**：调用`resolve`后，Promise的状态变为`fulfilled`，表示操作成功完成
- **Rejected（已失败）**：调用`reject`后，Promise的状态变为`rejected`，表示操作失败

```js
new Promise((resolve, reject) => {
  // 假设这里是一些异步操作，比如一个网络请求
  if (/* 条件 */) {
    resolve('成功的数据');
  } else {
    reject('失败的原因');
  }
})
.then(data => {
  console.log(data); // 处理成功的数据
})
.catch(error => {
  console.error(error); // 处理错误
})
.finally(() => {
  console.log('操作完成，无论成功还是失败都会执行这里的代码。');
  // 这里可以进行一些清理工作，比如关闭加载指示器
});
```

## 创建Promise

创建一个新的Promise时，需要提供一个执行器函数（executor function），这个函数接受两个参数：`resolve`和`reject`。这两个参数也是函数，用于在异步操作成功或失败时改变Promise的状态

```js
const myPromise = new Promise((resolve, reject) => {
  // 异步操作
  const success = true; // 假设这是异步操作的结果

  if (success) {
    resolve('Operation succeeded');
  } else {
    reject('Operation failed');
  }
});
```

## 处理Promise

使用`then`方法为Promise添加成功和失败的回调函数。`then`方法接受两个可选参数：第一个是成功时的回调函数，第二个是失败时的回调函数

```js
myPromise
  .then((value) => {
    console.log(value); // 如果Promise成功，输出"Operation succeeded"
  })
  .catch((error) => {
    console.log(error); // 如果Promise失败，输出"Operation failed"
  });
```

## 基本用法示例

使用Promise的简单例子，模拟一个异步操作，比如从服务器获取数据：

```js
function fetchData() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      const success = true;
      if (success) {
        resolve('Data fetched successfully');
      } else {
        reject('Failed to fetch data');
      }
    }, 2000);
  });
}

fetchData()
  .then((message) => {
    console.log(message); // 如果成功，输出"Data fetched successfully"
  })
  .catch((error) => {
    console.log(error); // 如果失败，输出"Failed to fetch data"
  });
```

## 结合async和await

`async`和`await`是建立在Promise之上的，在使用`async`和`await`时，可以像编写同步代码一样编写异步代码，同时保留了Promise的强大功能，如链式调用和错误处理

Promise链

> 在Promise中，可以使用`.then()`和`.catch()`方法来处理异步操作的结果。这种方式可能导致代码中出现“回调地狱”

```js
    fetch('https://api.example.com/data')
      .then(response => response.json())
      .then(json => console.log(json))
      .catch(error => console.error('Error fetching data:', error));
```

使用async/await简化Promise链，可以将上述Promise链转换成更易读的形式

```js
    async function fetchData() {
      try {
        let response = await fetch('https://api.example.com/data');
        let json = await response.json();
        console.log(json);
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    }
```

