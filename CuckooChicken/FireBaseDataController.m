//
//  FireBaseDataController.m
//  CuckooChicken
//
//  Created by 魏凡皓 on 2016/10/12.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "FireBaseDataController.h"

@import Firebase;
@interface FireBaseDataController()

@end

@implementation FireBaseDataController

-(instancetype)init{
    self = [super init] ;
    _userDataMail = [NSMutableArray new] ;
    _userDataPassword =[NSMutableArray new];
    
    return self ;
}
//讀取Firebase資料
-(void)setupRemoteConfig{
    
    __block NSDictionary * post;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    //只讀取一次  observeSingleEventOfType
    //數值改變讀取
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        post = snapshot.value;
        
       // _viewLabel.text = post[@"condition"];
    }];
    
    for(id key in post[@"mail"]) {
        _userDataMail = [post [@"mail"] objectForKey:key];
    }
    for(id key in post[@"password"]) {
        _userDataPassword = [post [@"password"] objectForKey:key];
    }
    
}

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
//    
//}

@end
