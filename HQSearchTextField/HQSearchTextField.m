//
//  HQSearchTextField.m
//  HQSearchTextField
//
//  Created by 洪强 on 2019/2/25.
//  Copyright © 2019 洪强. All rights reserved.
//

#import "HQSearchTextField.h"

@interface HQSearchTextField ()

@property (nonatomic, strong) UIView            *leftInputView;     // 左边输入视图
@property (nonatomic, strong) UIImageView       *leftImageView;     // 搜索图片
@property (nonatomic, strong) UIViewController  *controller;

@end

@implementation HQSearchTextField

// .h中警告说delegate在父类已经声明过了，子类再声明也不会重新生成新的方法了。我们就在这里使用@dynamic告诉系统delegate的setter与getter方法由用户自己实现，不由系统自动生成
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame WithController:(UIViewController *)controller {
    
    if (self = [super initWithFrame:frame]) {
        
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.placeholder = @"请输入搜索内容";
        // 设置输入框内容的字体样式和大小
        self.font = [UIFont fontWithName:@"Arial" size:16.0f];
        self.textColor = [UIColor blackColor];
        self.controller = controller;
        
        [self addNSNotificationAndObserver];
    }
    return self;
}

#pragma Set & Get
- (void)setDelegate:(id<HQSearchDelegate>)delegate {
    
    super.delegate = delegate;
}

- (id<HQSearchDelegate>)delegate {
    
    id curDelegate = super.delegate;
    return curDelegate;
}

- (void)setPlaceholder:(NSString *)placeholder {

    super.placeholder = placeholder;
    [self keyboardWillHide];
}

- (UIView *)leftInputView {
    
    if (!_leftInputView) {
        
        _leftInputView =  [[UIView alloc] init];
        _leftInputView.frame = CGRectMake(0, 0, inputW, inputW);
    }
    return _leftInputView;
}

- (UIImageView *)leftImageView {
    
    if (!_leftImageView) {
        
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"searchImg"];
    }
    return _leftImageView;
}

#pragma mark - 监听键盘的事件
- (void)addNSNotificationAndObserver {
    
    // 监听键盘的事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow {
    
    self.leftInputView.frame = CGRectMake(0, 0, inputW, inputW);
    CGRect rx = CGRectMake(12, (inputW - imgSearchW)/2, imgSearchW, imgSearchW);
    self.leftImageView.frame = rx;
    [self.leftInputView addSubview:self.leftImageView];
    self.leftView = self.leftInputView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

// 键盘关闭时动画
- (void)keyboardWillHide {
    
    CGRect textRect = [self.placeholder boundingRectWithSize:CGSizeMake(DBL_MAX, DBL_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: self.font} context:nil];
    CGFloat textFieldW = (self.frame.size.width - textRect.size.width)/2;
    self.leftInputView.frame = CGRectMake(0, 0, textFieldW, inputW);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputViewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.leftInputView addGestureRecognizer:tap];
    
    CGRect rx = CGRectMake(textFieldW -12, (inputW - imgSearchW)/2, imgSearchW, imgSearchW);
    self.leftImageView.frame = rx;
    
    [self.leftInputView addSubview:self.leftImageView];
    self.leftView = self.leftInputView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)inputViewTapped {
    
    [self becomeFirstResponder];
}

- (void)dealloc {
    
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


@end
