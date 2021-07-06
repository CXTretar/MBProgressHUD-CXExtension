//
//  CXViewController.m
//  MBProgressHUD-CXExtension
//
//  Created by CXTretar on 07/03/2021.
//  Copyright (c) 2021 CXTretar. All rights reserved.
//

#import "CXViewController.h"
#import <MBProgressHUD_CXExtension/MBProgressHUD+CXExtension.h>

@interface CXViewController ()

@end

@implementation CXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [MBProgressHUD cx_showToastInView:self.view title:@"123123" icon:@"ea10" image:nil duration:1.5f mask:YES];
}

@end
