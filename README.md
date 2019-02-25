---
title: 基于textField的搜索框
date: 2019.02.25
categories: 
- iOS
tags:
- iOS
- Objective-C
- 控件封装
---

### 最终效果图

![image-20190223165039223](https://github.com/dusmit/HQSearchTextField/blob/master/20190225-163252.gif)

### 使用方法

```objective-c
    HQSearchTextField *searchTextField = [[HQSearchTextField alloc] initWithFrame:CGRectMake(15, 60, self.view.frame.size.width - 30, 30) WithController:self];
    searchTextField.placeholder = @"请输入您要搜索的内容";
    searchTextField.delegate = self;
    self.searchTextField = searchTextField;
    [self.view addSubview:searchTextField];
```

![image-20190223165039223](https://github.com/dusmit/HQSearchTextField/blob/master/450AF068-6608-4CDD-B820-70D15DAEA1B0.png)

### 遇到的问题

1.关于代理问题

使用UITextFeild子类，在引用代理时如何像UITableView引用UIScrollView代理一样？参见 [iOS delegate继承（协议、代理的继承)](https://www.jianshu.com/p/0e3a940dd4cf)，万分感谢！其实在这里如果没有定义新的代理也可以直接用UITextFieldDelegate。

2.关于设置 `placeholder` 属性问题

我默认在 `HQSearchTextField.m` 的初始化方法中预设了 `placeholder` 的值，但是当使用时如果重新自定义赋值时，由于在初始化时设置了 `leftInputView` 的 `frame` ，显示时会出现使用的 `frame` 是我预定的 `placeholder` 计算的值，开始时考虑使用setter方法，但是引用 `_placeholder` 一直报错，所以有了方法3，方法2是我修改后的。

解决方法：

1. 在初始化函数时传入自定义的值，但是这样做会使代码看起来怪怪的；

   ```objective-c
       HQSearchTextField *searchTextField = [[HQSearchTextField alloc] initWithFrame:CGRectMake(15, 60, self.view.frame.size.width - 30, 30) WithController:self WithPlaceholder:@"请输入您要搜索的内容"];
       searchTextField.placeholder = @"请输入您要搜索的内容";
       searchTextField.delegate = self;
       self.searchTextField = searchTextField;
       [self.view addSubview:searchTextField];
   ```

2. 使用setter方法，赋值时改变 `frame` ；

   ```objective-c
   - (void)setPlaceholder:(NSString *)placeholder {
   
       super.placeholder = placeholder;
       
       //do some things...
       
   }
   ```

3. KVO监听 `placeholder` 值，有变化时改变 `frame` ；

   ```objective-c
       // 添加监听事件，监听placeholder值的变化，并刷新frame
       [self addObserver:self forKeyPath:@"placeholder" options:NSKeyValueObservingOptionNew context:nil];
   ```

   ```objective-c
   - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
       
       if ([keyPath isEqualToString:@"placeholder"]) {
           
           // do some things...
           
       }
   }
   ```

   ```objective-c
       // 移除观察者
       [self removeObserver:self forKeyPath:@"placeholder"];
   ```

如果有更好的方法或有任何意见或建议，请联系我 `邮箱：dusmit@qq.com` ，望不吝赐教，万分感激。

### 扩展

本想封装进一个自带的tableview，还没有完成。

### 项目地址

[GitHub](https://github.com/dusmit/HQSearchTextField)