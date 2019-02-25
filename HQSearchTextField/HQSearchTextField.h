//
//  HQSearchTextField.h
//  HQSearchTextField
//
//  Created by 洪强 on 2019/2/25.
//  Copyright © 2019 洪强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQSearchTextField;

#define inputW          30
#define imgSearchW      15

// 参考 https://www.jianshu.com/p/0e3a940dd4cf 万分感谢作者
@protocol HQSearchDelegate <UITextFieldDelegate>

@optional

@end

@interface HQSearchTextField : UITextField

@property (nonatomic, weak) id<HQSearchDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame WithController:(UIViewController *)controller;

@end
