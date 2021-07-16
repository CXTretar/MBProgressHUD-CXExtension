//
//  CXViewController.m
//  MBProgressHUD-CXExtension
//
//  Created by CXTretar on 07/03/2021.
//  Copyright (c) 2021 CXTretar. All rights reserved.
//

#import "CXViewController.h"
#import <MBProgressHUD_CXExtension/MBProgressHUD+CXExtension.h>

@interface CXViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CXViewController

#pragma mark - 🛩 ClassMethods

#pragma mark - 🚑 LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupSubViews];
    [self __setupData];
}

#pragma mark - 🚌 Public

#pragma mark - 🚓 UIEvents

- (void)showToastInView {
    [MBProgressHUD cx_showToastInView:self.view title:@"success" icon:@"ea10" image:nil duration:2.0 mask:YES];
}

- (void)showToastInWindow {
    [MBProgressHUD cx_showToastInWindowWithTitle:@"success" icon:@"ea10" image:nil duration:2.0 mask:YES];
}

- (void)showLoadingInView {
    [MBProgressHUD cx_showLoadingInView:self.view title:@"loading..." mask:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD cx_hideHUD];
    });
}

- (void)showLoadingInWindow {
    [MBProgressHUD cx_showLoadingInWindowWithTitle:@"loading..." mask:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD cx_hideHUD];
    });
}

#pragma mark - 👨‍👦Override

#pragma mark - 🚗 Private

#pragma mark - 🚲 Private - Setup

- (void)__setupSubViews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [self.view addSubview:self.tableView];
}

- (void)__setupData {
    self.dataSource = @[
        @"showToastInView",
        @"showToastInWindow",
        @"showLoadingInView",
        @"showLoadingInWindow",
    ];
    [self.tableView reloadData];
}

#pragma mark - 🛴 Delegate
#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL sel = NSSelectorFromString(self.dataSource[indexPath.row]);
    if (sel && [self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel];
#pragma clang diagnostic pop
    }
}

#pragma mark - 🛰 KVO

#pragma mark - 🚁 Notification

#pragma mark - 🔧 Tools

#pragma mark - 🚚 Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

@end
