# Array数组原型方法

## 数组修改方法

### `push`方法

> `push`方法用于向数组的末尾添加一个或多个元素，并返回数组的新长度

```js
array.push(element1, ..., elementN)
```

- `element1, ..., elementN`：要添加到数组末尾的元素

```js
let arr = [1, 2, 3];

// 向数组末尾添加一个元素
let newLength = arr.push(4);
console.log(arr);        // 输出: [1, 2, 3, 4]
console.log(newLength);  // 输出: 4（数组的新长度）

// 向数组末尾添加多个元素
newLength = arr.push(5, 6);
console.log(arr);        // 输出: [1, 2, 3, 4, 5, 6]
console.log(newLength);  // 输出: 6（数组的新长度）
```

### `shift`方法

> `shift`方法用于从数组的开头移除第一个元素，并返回被移除的元素。如果数组为空，则返回`undefined`

```js
array.shift()
```

```js
let arr = [1, 2, 3];

// 从数组开头移除第一个元素
let removedElement = arr.shift();
console.log(arr);          // 输出: [2, 3]
console.log(removedElement); // 输出: 1（被移除的元素）

// 再次从数组开头移除第一个元素
removedElement = arr.shift();
console.log(arr);          // 输出: [3]
console.log(removedElement); // 输出: 2（被移除的元素）
```

### `splice`方法

> `splice`方法在原数组上进行修改，并返回一个包含被删除元素的数组（如果没有元素被删除，则返回一个空数组）

```js
array.splice(start[, deleteCount[, item1[, item2[, ...]]]])
```

- `start`：指定修改开始的位置（数组索引）
- `deleteCount`：可选，表示要移除的数组元素的个数
- `item1, item2, ...`：可选，表示要添加进数组的元素，从`start`位置开始

如果`splice`方法有额外的参数，它们将被插入到`start`指定的位置

```js
let arr = [1, 2, 3, 4, 5];

// 从索引1开始删除1个元素，并在删除的位置插入元素 "a" 和 "b"
let removedElements = arr.splice(1, 1, "a", "b");

console.log(arr);            // 输出: [1, "a", "b", 3, 4, 5]
console.log(removedElements); // 输出: [2]（被删除的元素）
```

### `slice`方法

> `slice`方法能够截取数组的一部分并返回一个新数组，而不会修改原数组

```js
array.slice([begin[, end]])
```

- `begin`：可选，一个整数，表示截取数组的起始索引。如果`begin`为负数，则表示从数组末尾开始的第几位（从-1计数）。如果省略`begin`，则默认从数组的第一个元素开始截取
- `end`：可选，一个整数，表示截取数组的结束索引（不包括`end`位置的元素）。如果`end`为负数，则表示从数组末尾开始的第几位（从-1计数）。如果省略`end`，则默认截取到数组的最后一个元素

```js
let fruits = ['Banana', 'Orange', 'Lemon', 'Apple', 'Mango'];
let citrus = fruits.slice(1, 3);
console.log(citrus); // 输出: ['Orange', 'Lemon']

let fruitsCopy = fruits.slice();
console.log(fruitsCopy); // 输出: ['Banana', 'Orange', 'Lemon', 'Apple', 'Mango']
```

## 数组遍历方法

### `forEach`方法

> `forEach` 方法对数组的每个元素执行一次提供的函数。

```js
array.forEach(function(currentValue, index, array) {
  // ... 执行的操作
});
```

- `currentValue`：数组中正在处理的当前元素
- `index`：（可选）数组中正在处理的当前元素的索引
- `array`：（可选）`forEach`方法正在操作的数组

```js
let numbers = [1, 2, 3, 4, 5];

numbers.forEach(function(number) {
  console.log(number * 2);
});
// 输出: 2 4 6 8 10
```

> `forEach`方法没有返回值，它总是返回`undefined`。它直接修改原数组中的元素（如果函数体内有修改操作）

### `map`方法

> `map`方法创建一个新数组，其结果是该数组中的每个元素都调用一个提供的函数

```js
let newArray = array.map(function(currentValue, index, array) {
  // ... 返回新值
});
```

- `currentValue`：数组中正在处理的当前元素
- `index`：（可选）数组中正在处理的当前元素的索引
- `array`：（可选）`map`方法正在操作的数组

```js
let numbers = [1, 2, 3, 4, 5];

let doubled = numbers.map(function(number) {
  return number * 2;
});
console.log(doubled); // 输出: [2, 4, 6, 8, 10]
```

> `map`方法返回一个新的数组，包含对原数组每个元素调用提供的函数的结果

### `filter`方法

> `filter`方法创建一个新数组，包含通过所提供函数实现的测试的所有元素

```js
let newArray = array.filter(function(currentValue, index, array) {
  // ... 返回 true 或 false
});
```

- `currentValue`：数组中正在处理的当前元素
- `index`：（可选）数组中正在处理的当前元素的索引
- `array`：（可选）`filter`方法正在操作的数组

```js
let numbers = [1, 2, 3, 4, 5];

let evens = numbers.filter(function(number) {
  return number % 2 === 0;
});
console.log(evens); // 输出: [2, 4]
```

> `filter`方法返回一个新的数组，包含所有使得提供的函数返回 `true` 的元素。

### `find`方法

> `find`方法返回数组中满足提供的测试函数的第一个元素的值。如果没有找到匹配的元素，则返回`undefined`

```js
let value = array.find(function(currentValue, index, array) {
  // ... 返回 true 或 false
});
```

- `currentValue`：数组中正在处理的当前元素
- `index`：（可选）数组中正在处理的当前元素的索引
- `array`：（可选）`find`方法正在操作的数组

```js
let numbers = [1, 2, 3, 4, 5];

let found = numbers.find(function(number) {
  return number > 3;
});
console.log(found); // 输出: 4
```

> `find` 方法返回数组中第一个使得提供的函数返回 `true` 的元素，否则返回`undefined`

## 数组转换方法

### `join`方法

> `join` 方法将数组（或一个类数组对象）的所有元素连接成一个字符串并返回这个字符串。元素之间可以用一个分隔符分隔，默认为逗号（`,`）

```js
array.join([separator])
```

- `separator`：可选，指定一个字符串来分隔数组的每个元素。如果省略，则默认为逗号（`,`）

```js
let arr = ['Hello', 'World', '!'];

// 使用默认分隔符（逗号）连接数组元素
let str = arr.join();
console.log(str); // 输出: "Hello,World,!"

// 使用空字符串作为分隔符连接数组元素
str = arr.join('');
console.log(str); // 输出: "HelloWorld!"

// 使用自定义分隔符（空格）连接数组元素
str = arr.join(' ');
console.log(str); // 输出: "Hello World !"
```