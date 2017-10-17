//
//  ViewController.m
//  Thread_Demo(多线程)
//
//  Created by 马金丽 on 17/10/16.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property(nonatomic,assign)NSInteger ticktCount;    //演唱会门票数量
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"NSThread";
//    [self threadCommunicate];
    _ticktCount = 50;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame =  CGRectMake(20, 64, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"售票" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)startBtnClick:(UIButton *)sender {
    
//    [self threadTest];
    
    [self sellTicketForThread];

    
}



#pragma mark -模拟售票
- (void)sellTicketForThread
{
    //监听线程退出的通知,以便知道线程是什么时候退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadExitThreadNotice) name:NSThreadWillExitNotification object:nil];
    
    //创建两个线程:代表两个售票窗口
    NSThread *window1 = [[NSThread alloc]initWithTarget:self selector:@selector(thread1) object:nil];
    window1.name = @"北京售票窗口";
    [window1 start];
    
    NSThread *window2 = [[NSThread alloc]initWithTarget:self selector:@selector(thread2) object:nil];
    window2.name = @"苏州售票窗口";
    [window2 start];
    
    [self performSelector:@selector(saleTicketAction) onThread:window1 withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(saleTicketAction) onThread:window2 withObject:nil waitUntilDone:NO];
    }

//为了使线程一直开放
- (void)thread1
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop runUntilDate:[NSDate date]];   //一直运行
}

- (void)thread2
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];//自定义运行时间
    
}

- (void)threadExitThreadNotice
{
    NSLog(@"线程将要退出");
}

- (void)saleTicketAction
{
    NSLog(@"售票");
    while (1) {
        NSLock *lock = [[NSLock alloc]init];
        [lock lock];
        if (_ticktCount > 0) {
            _ticktCount --;
            NSLog(@"%@",[NSString stringWithFormat:@"剩余票数:%ld 窗口:%@",_ticktCount,[NSThread currentThread].name]);
            [NSThread sleepForTimeInterval:0.2];    //暂停0.2秒
            
        }else{//如果已经卖完
            if ([NSThread currentThread].isCancelled) {
                break;
            }else{
                NSLog(@"售卖完毕");
                [[NSThread currentThread] cancel];
                CFRunLoopStop(CFRunLoopGetCurrent());
            }
            
        }
        [lock unlock];
//        @synchronized (self) {
//            
//        }
        
    }
}

#pragma mark -NSThread

- (void)threadTest
{
    //动态创建
    NSThread *myThread = [[NSThread alloc]initWithTarget:self selector:@selector(threadRun) object:nil];
    [myThread setQualityOfService:NSQualityOfServiceUserInitiated];
    [myThread start];

    
}



- (void)threadRun
{
    NSInteger all = 0;
    for (int i = 0; i < 1000; i++) {
        all += i;
        [self performSelectorOnMainThread:@selector(mainThreadAction) withObject:nil waitUntilDone:YES];
    }
    NSLog(@"0到1000的总数和:%ld",(long)all);
    NSLog(@"当前线程22222:%@  主线程:%@",[NSThread currentThread],[NSThread mainThread]);

}

#pragma mark -线程间的通信
- (void)threadCommunicate
{
    //1.指定当前线程执行操作
    [self performSelector:@selector(currentThradAction)];
    [self performSelector:@selector(currentThradAction) withObject:nil];
    [self performSelector:@selector(currentThradAction) withObject:nil afterDelay:0.3];
    
}

- (void)currentThradAction
{
    NSLog(@"当前线程执行操作");
}

- (void)mainThreadAction
{
    NSLog(@"在其他线程中指定主线程执行操作");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
