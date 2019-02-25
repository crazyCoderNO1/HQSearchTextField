//
//  ViewController.m
//  HQSearchTextField
//
//  Created by 洪强 on 2019/2/25.
//  Copyright © 2019 洪强. All rights reserved.
//

#import "ViewController.h"
#import "HQSearchTextField.h"

@interface ViewController () <HQSearchDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HQSearchTextField *searchTextField;
@property (nonatomic, strong) NSMutableArray    *dataSource;
@property (nonatomic, strong) UIView            *backView;
@property (nonatomic, strong) UITableView       *searchTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];

    HQSearchTextField *searchTextField = [[HQSearchTextField alloc] initWithFrame:CGRectMake(15, 60, self.view.frame.size.width - 30, 30) WithController:self];
    searchTextField.placeholder = @"请输入您要搜索的内容";
    searchTextField.delegate = self;
    self.searchTextField = searchTextField;
    [self.view addSubview:searchTextField];
    
    // 添加手势
    [self addViewTapped];
}

// 键盘弹出通知，改变tableview的frame
- (void)keyboardWillShow:(NSNotification *)notif {
    
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (self.searchTableView) {
        
        self.searchTableView.frame = CGRectMake(self.searchTableView.frame.origin.x, self.searchTableView.frame.origin.y, self.searchTableView.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(self.searchTextField.frame)-10-height);
    }
}

// 添加手势，单击收起键盘
- (void)addViewTapped {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

// 响应手势事件
- (void)viewTapped:(UITapGestureRecognizer *)tap {
    
    if ([self.searchTextField.text length] == 0) {
        
        [self.searchTextField endEditing:YES];
        [self.backView removeFromSuperview];
    }
}

// 搜索结果
- (void)getSearchResult:(NSString *)text {
    
    //textFiled 改变，执行数据请求
    [self.dataSource removeAllObjects];
    NSArray *array = @[@"12345",@"12346",@"1245",@"1246",@"111",@"123",@"100",@"1"];
    for (NSString *arrText in array) {
        if ([arrText hasPrefix:text]) {
            
            [self.dataSource addObject:arrText];
        }
    }
    [self.searchTableView reloadData];
}

// textfield的text改变通知，相应搜索结果
- (void)textFieldTextDidChange {
    
    if (self.searchTextField.text.length == 0) {
        self.searchTableView.alpha = 0;
        return;
    }
    if (self.searchTextField.text.length > 0) {
        self.searchTableView.alpha = 1;
    }
    [self getSearchResult:self.searchTextField.text];
}

#pragma mark -- tableViewDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchTextField.frame)+10, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-CGRectGetMaxY(self.searchTextField.frame)-30)];
        backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.backView = backView;
        [self.view addSubview:backView];
        
        UITableView *searchTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        searchTableView.alpha = 0;
        searchTableView.tableFooterView = [[UIView alloc]init];
        searchTableView.delegate = self;
        searchTableView.dataSource = self;
        self.searchTableView = searchTableView;
        [self.backView addSubview:searchTableView];
    }
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"SearchViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

// Controller销毁时移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


@end
