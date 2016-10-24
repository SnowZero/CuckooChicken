//
//  ViewController.m
//  CuckooChicken
//
//  Created by Snos on 2016/9/12.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "ViewController.h"
#import "FireBaseManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FirebaseAuth/FirebaseAuth.h>

@import Firebase;


@interface ViewController ()<FBSDKLoginButtonDelegate>
{
//    FIRDatabaseReference *ref;
    NSTimer * test;
    NSDictionary * post;
}
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self starGetFirebase];
    
//    test = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(aaa) userInfo:nil repeats:true];
    
    // 在ViewController創造一個Facebook的登入按鈕(Facebook版)
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
    
    // Facebook官方登入方法
//    NSArray *permissions = [[NSArray alloc] initWithObjects:
//                            @"email",
//                            nil];
//    
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logOut];
//    
//    [login
//     logInWithReadPermissions: permissions
//     fromViewController:self
//     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//         
//         if (error) {
//             NSLog(@"Process error");
//         } else if (result.isCancelled) {
//             NSLog(@"Cancelled");
//         } else {
//             NSLog(@"Logged in %@", result.token.userID);
//         }
//         
//     }];

    

    
}

- (IBAction)fbTest:(UIButton *)sender {
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    loginButton.center = self.view.center;
    loginButton.delegate = self;
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(FBSDKLoginButton *)loginButton



didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if (error == nil) {
        
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                         .tokenString];
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      
                                      
                                  NSLog(@"登入成功");
                                  }];
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
}

@end
