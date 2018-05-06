//
//  RACTestDelegateViewController.h
//  RACTest1
//
//  Created by zhi on 2018/5/6.
//  Copyright © 2018年 linqiangz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

@interface RACTestDelegateViewController : UIViewController

@property (nonatomic, strong) RACSubject *signalDelegate;

@end
