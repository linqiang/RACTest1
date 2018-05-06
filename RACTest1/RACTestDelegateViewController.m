//
//  RACTestDelegateViewController.m
//  RACTest1
//
//  Created by zhi on 2018/5/6.
//  Copyright © 2018年 linqiangz. All rights reserved.
//

#import "RACTestDelegateViewController.h"
@interface RACTestDelegateViewController ()

@end

@implementation RACTestDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//利用RAC实现代理功能
- (IBAction)btnClick:(id)sender {
    if (self.signalDelegate) {
        [self.signalDelegate sendNext:self.class];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
