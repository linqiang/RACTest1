//
//  ViewController.m
//  RACTest1
//
//  Created by zhi on 2018/4/19.
//  Copyright © 2018 linqiangz. All rights reserved.
//  

#import "ViewController.h"
#import "RACTestDelegateViewController.h"
#import "ReactiveObjC.h"
@interface ViewController ()
@property (nonatomic, strong) RACCommand *command;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
//    [self signalTest1];
//    [self replaySubjectTest];
//    [self subjectTest];
//    [self racmutlitConnection];
    [self racCommandTestDemo];
}

- (void)racCommandTestDemo{
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        NSLog(@"执行命令");
        
        // 创建空信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    _command = command;
    
    
  
    
    // 3.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        
        [x subscribeNext:^(id x) {
            
            NSLog(@"_____%@",x);
        }];
        
    }];
    // 4.执行命令
    [self.command execute:@1];
    
}


//4. 如果需要多次订阅一个信号，就会导致多次请求，这时就可以去使用RACMulticastConnection
// 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
// 解决：使用RACMulticastConnection就能解决.
- (void)racmutlitConnection{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSLog(@"在这里发送数据");
        [subscriber sendNext:@"1"];
        return nil;
    }];
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"这里接收数据");
//    }];
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"这里接收数据2");
//    }];
   
    
    RACMulticastConnection *muliticast = [signal publish];
    [muliticast.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"这里接收数据%@",x);
    }];
    [muliticast.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"这里接收数据2%@",x);
    }];
    [muliticast connect];
    
    
    // 可以通过这个进行比较，两种订阅信号发送信号的区别
}

- (void)replaySubjectTest{
    // 1. 简单使用RACReplaySubject

    // 2.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 3.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    // 如果你看了这份代码，你可以尝试先订阅信号和后订阅信号，发送信号的区别

    RACReplaySubject *replaySub = [RACReplaySubject subject];
    
   
    //订阅信号
    [replaySub subscribeNext:^(id  _Nullable x) {
         NSLog(@"收到%@的信号",x);
    }];
    
    [replaySub subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到%@的信号2",x);
    }];
    
    //发送信号
    [replaySub sendNext:@"StarBucks"];
    [replaySub sendNext:@"Cetbon"];
    
}

- (void)subjectTest{
   
    // 简单使用Subject

    RACSubject *subject = [RACSubject subject];
   
    //订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"________%@",x);
    }];
     //发送信号
    [subject sendNext:@"StarBucks"];
    [subject sendNext:@"Cetbon"];
}


- (IBAction)btnClick:(id)sender {
    RACTestDelegateViewController *racTestVC = [[RACTestDelegateViewController alloc] init];
   // 设置代理信号
    racTestVC.signalDelegate = [RACSubject subject];
    //订阅信号
    [racTestVC.signalDelegate subscribeNext:^(id  _Nullable x) {
        // 这里是点击按钮之后的处理
        NSLog(@"%@发出来理消息",x);
    }];
    [self presentViewController:racTestVC animated:YES completion:nil];
}


- (void)signalTest1{
     //简单实现信号订阅和传递
    // 1.创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 2.发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        //        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
