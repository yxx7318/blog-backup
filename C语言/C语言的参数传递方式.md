# C语言的参数传递方式

1. 值传参-> 在传参过程中，首先将c的值复制给函数c变量，然后在函数中修改的即是函数的c变量，然后函数返回时，系统自动释放变量c。而对main函数的c没有影响。

2. 指针传参(地址传参)-> 将变量的地址直接传入函数，函数中可以对其值进行修改。

3. 引用传参-> 将变量的引用传入函数，效果和指针相同，同样函数中可以对其值进行修改。

## 值传递

```c
#include<stdio.h>
void max(int a);
int main(){
	int b=10;
	max(b);
    printf("%d",b);	//输出结果为10
} 
void max(int a){
    a=20;	//a复制了b的值，但两者在地址中的位置不同，a改变不影响b
}
```

## 地址传递

```c
#include<stdio.h>
void max(int *a);
int main(){
	int b=10;
	max(&b);
    printf("%d",b);	//运行结果为20
} 
void max(int *a){
    *a=20;	//a和b同地址，a改变地址上内容会引起b地址上的内容改变
}
```

**(编译器版本有时候会存在一点问题，以下方式可能会失败
		int *b;
		*b=10;
		max(b);
需要通过以下的方式才能保证传递另外一个指针的地址给形参
    	int b=10;
		int *c=&b;
		max(c);)**

## 引用传递

```c
#include<stdio.h>
void max(int &a);
int main(){
	int b=10;
	max(b);
	printf("%d\t",b);	//运行结果为20
} 
void max(int &a){
	printf("%d",a);	//运行结果为10
	a=20;	//a在函数内作为b"别名"存在，a的值改变就代表b改变
}
```

## 总结

```c
a=b;	//a复制了b的值
*a=&b;	//a和b同地址，a改变地址上内容会引起b地址上的内容改变
&a=b;	//a在函数内作为b"别名"存在，a的值改变就代表b改变
```
