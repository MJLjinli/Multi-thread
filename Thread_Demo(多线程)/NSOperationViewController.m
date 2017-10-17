//
//  NSOperationViewController.m
//  Thread_Demo(多线程)
//
//  Created by 马金丽 on 17/10/17.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()
@property(nonatomic,copy)NSString *imageUrl;
@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"NSOperation";
   

}


- (IBAction)childInvoOperationBtnClick:(id)sender {
     _imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508217225808&di=2f85dcd8a1c680d992ceb3cd6edd672f&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F72f082025aafa40fe871b36bad64034f79f019d4.jpg";
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImageSSource:) object:_imageUrl];
//    [invocationOperation start];不添加在队列里,直接start,此时会在当前线程主线程中执行
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:invocationOperation];
    
    
}
- (IBAction)childBlockOperationBtnClick:(id)sender {
    
    _imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508217615253&di=6834e6b0c23e1d4adb339fa5c1633c81&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101120%2F5861439_143344091908_2.jpg";
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf loadImageSSource:weakSelf.imageUrl];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:blockOperation];
}

- (IBAction)otherQueueBtnClick:(id)sender {
    //创建一个队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //最大并发数,用来设置最多可以让多少个operation同时执行
    queue.maxConcurrentOperationCount = 1;
    __weak typeof(self) weakSelf = self;

    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
//        for (int i = 0; i < 5000000; i++) {
//            if (i == 0) {
//                NSLog(@"operation1中任务1->开始");
//            }
//            if (i == 4999999) {
//                NSLog(@"operation1中任务1->完成");
//            }
//        }
        [weakSelf loadImageSSource:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508217615253&di=6834e6b0c23e1d4adb339fa5c1633c81&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101120%2F5861439_143344091908_2.jpg"];
        NSLog(@"任务1");

    }];
    
    //给operation1添加一个任务
    [operation1 addExecutionBlock:^{
//        for (int i = 0; i < 5000000; i++) {
//            if (i == 0) {
//                NSLog(@"operation1中任务2->开始");
//            }
//            if (i == 4999999) {
//                NSLog(@"operation1中任务2->完成");
//            }
//        }
    }];
    
    operation1.completionBlock = ^(){
      
        NSLog(@"operation1执行完毕");
    };
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
//        for (int i = 0; i < 5000000; i++) {
//            if (i == 0) {
//                NSLog(@"operation2中任务2->开始");
//            }
//            if (i == 4999999) {
//                NSLog(@"operation2中任务2->完成");
//            }
//        }
        [weakSelf loadImageSSource:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508220003374&di=7af0556225bd0de21fb3bf843e05189b&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F241f95cad1c8a7865c9465236c09c93d70cf5064.jpg"];
        NSLog(@"任务2");

    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
       
        [weakSelf loadImageSSource:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508217225808&di=2f85dcd8a1c680d992ceb3cd6edd672f&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F72f082025aafa40fe871b36bad64034f79f019d4.jpg"];
        NSLog(@"任务3");
    }];
    
    //2个operation是串行的,但是同一个operation中的任务是并行的
    [queue addOperations:@[operation1,operation2,operation3] waitUntilFinished:NO];

    //设置任务依赖
//    [operation2 addDependency:operation1];  //Operation2依赖Operation1.那么只有Operation1完成了才执行Operation2
    //暂停任务队列
//    [queue setSuspended:YES];
    //继续
//    [queue setSuspended:NO];
    //取消单个操作
//    [operation1 cancel];
    //取消queue中的所有操作
//    [queue cancelAllOperations];
    
}


- (void)loadImageSSource:(NSString *)str
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    UIImage *image = [UIImage imageWithData:imageData];
    if (imageData != nil) {
        [self performSelectorOnMainThread:@selector(refreshUI:) withObject:image waitUntilDone:YES];
    }
    NSLog(@"开启新线程下载图片");
    
}

- (void)refreshUI:(UIImage *)image
{
    self.mainImageView.image = image;
    NSLog(@"主线程刷新UI");
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
