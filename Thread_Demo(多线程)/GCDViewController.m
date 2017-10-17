//
//  GCDViewController.m
//  Thread_Demo(多线程)
//
//  Created by 马金丽 on 17/10/17.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    //并行队列
//    dispatch_queue_t cqueue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
//    
//    dispatch_queue_t squeue = dispatch_queue_create("stest.queue", DISPATCH_QUEUE_SERIAL);
//    //同步执行
//    dispatch_sync(cqueue, ^{
//        
//    });
//    //异步执行
//    dispatch_async(squeue, ^{
//        
//    });
//    [self gcdInfo];
    [self gcdGroup];

}
//并行+同步:不会开启新线程,执行完一个任务,再执行下一个任务
- (IBAction)ConcurrentAndSyncBtnClick:(id)sender {
    
    NSLog(@"begin");
    dispatch_queue_t queue = dispatch_queue_create("cqueue.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"任务1%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务4%@",[NSThread currentThread]);
    });
    NSLog(@"end");
    
    //可以看出所有任务都是在主线程中执行的,因为只有一个线程,所以任务是一个一个的执行
    //所有的任务都是在begin和end之间,说明任务是添加到队列中马上执行的
    
}
//并行+异步
- (IBAction)ConcurrentAndAsyncBtnClick:(id)sender {
    
    NSLog(@"begin");
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务1%@",[NSThread currentThread]);
 
        }
    });
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务2%@",[NSThread currentThread]);
            
        }
    });
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务3%@",[NSThread currentThread]);
            
        }
    });
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务4%@",[NSThread currentThread]);
            
        }
    });

    NSLog(@"end");
    //可以看出又添加了3个线程,并且任务是交替着同时进行
    //所有任务是在执行过begin和end之后才开始执行的,说明任务不是马上执行,而是将所有任务添加到队列之后才开始异步执行.
}
//串行+同步
- (IBAction)SerialAndSSyncBtnClick:(id)sender {
    
    NSLog(@"begin");
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    NSLog(@"end");
    //可以看出所有任务都是在主线程中执行的,并且没有开启新的线程,因为是串行队列,所以任务是按照顺序一个一个的执行
    
}
//串行+异步
- (IBAction)SerialAndAsyncBtnClick:(id)sender {
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");

    //开启了新的线程,任务是一个一个的执行,所有任务添加到队列之后才开始执行
    
}
//主线程+同步
- (IBAction)mainAndSyncBtnClick:(id)sender {
    
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncMain---end");
    //任务不在执行,且卡主
    //这是因为这段代码是在主线程中执行的,同步执行是对于任务是立马执行的,那么当我们的第一个任务放在主队列中,它就会立马执行.但主线程现在正在处理mainAndSyncBtnClick这个方法,所以要等主线程处理完mainAndSyncBtnClick这个方法,但是主线程在执行mainAndSyncBtnClick这个方法的时候,又要等第一个任务完成才能执行下个任务.所以就任务互等了,执行不下去了.
}

- (IBAction)mainAsyncBtnClick:(id)sender {
    
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncMain---end");
    //因为主队列是串行队列,所以一个一个的执行
}


//GCD之间的通讯
- (void)gcdInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSLog(@"2------%@",[NSThread currentThread]);

        });
    });
}

//GCD的栅栏方法
- (IBAction)gcdBarrier:(id)sender {
    //有时候我们需要异步执行两组操作,而且第一组执行完成之后,才能开始执行第二组操作.
    dispatch_queue_t queue = dispatch_queue_create("barrier.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2------%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier------%@",[NSThread currentThread]);
 
    });
    dispatch_async(queue, ^{
        NSLog(@"3------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"4------%@",[NSThread currentThread]);
    });
    
}

- (IBAction)gcdApply:(id)sender {
    
  //例如for循环,for循环的做法是每次取出一个元素,逐个遍历,GCD提供dispatch_apply,可以同时遍历多个数字
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zu =====%@",index,[NSThread currentThread]);
        
    });
}

- (void)gcdGroup
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        //执行一个耗时操作
        for (int i = 0; i < 3; i++) {
            NSLog(@"耗时操作1--%@",[NSThread currentThread]);
        }
    });
    
   dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //执行一个耗时操作
       for (int i = 0; i < 3; i++) {
           NSLog(@"耗时操作2--%@",[NSThread currentThread]);
       }
   });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        NSLog(@"耗时操作完成之后,回到主线程--%@",[NSThread currentThread]);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
