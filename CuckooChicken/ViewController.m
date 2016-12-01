//
//  ViewController.m
//  CuckooChicken
//
//  Created by Snos on 2016/9/12.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "ViewController.h"
#import "FireBaseManager.h"

@import Firebase;


@interface ViewController ()
{
//    FIRDatabaseReference *ref;
    NSTimer * test;
    NSDictionary * post;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self starGetFirebase];
    
//    test = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(aaa) userInfo:nil repeats:true];
    
}


- (void) aaa {

//    if (post != nil) {
//        
//        FireBaseManager * testdata = [FireBaseManager newFBData];
//        [testdata setData:post];
//        
//        [test invalidate];
//        test = nil;
//
//        ViewController * svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInView"];
//        
//                    // 跳到下一頁
//                    [self presentViewController:svc animated:YES completion:nil];
//                    NSLog(@"跳到下一頁了");
//    
//    }
}


- (void)starGetFirebase{

    FIRDatabaseReference *ref;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        post = snapshot.value;
        
        NSLog(@"%@", post[@"user"][@"mail"]);
        NSLog(@"%@", post[@"user"][@"password"]);
        
    }];
    
}

//讀取Firebase資料
//-(void)getupRemoteConfig{
//    
//    
//    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
//    ref = [[FIRDatabase database] referenceFromURL:strUrl];
//    //只讀取一次  observeSingleEventOfType
//    //數值改變讀取
//    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSDictionary *post = snapshot.value;
//        _viewLabel.text = post[@"condition"];
//    }];
//}
//
//// setFirebase
//- (IBAction)setValueBtn:(id)sender {
//    
//    // [(路徑) child: @""] 去取得下一層欄位 如果沒有這個欄位則新增
//    
//    FIRDatabaseReference *test = [ref child:@"user"];
//    // childByAutoId 自動生成不重複的亂數ID 
//    test  = [test childByAutoId];
//    NSDictionary *data = @{@"name":@"AA",@"password":@"123"};
//    [test setValue:data];
//}

@end
