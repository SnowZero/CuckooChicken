//
//  RegisteredViewController.m
//  
//
//  Created by 魏凡皓 on 2016/9/20.
//
//

#import "RegisteredViewController.h"
#import "ViewController.h"
#import "FireBaseManager.h"

@import Firebase;

@interface RegisteredViewController ()
{
    NSString *mail;
    NSString *password;
    NSDictionary * managerData;
}

@property (weak, nonatomic) IBOutlet UITextField *registeredViewMail;
@property (weak, nonatomic) IBOutlet UITextField *registeredViewPassword;
@property (weak, nonatomic) IBOutlet UITextField *registeredViewCheckPassword;


@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void) viewDidAppear:(BOOL)animated {

    
//        FIRDatabaseReference *ref;
//        NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
//    
//        ref = [[FIRDatabase database] referenceFromURL:strUrl];
//    
//        [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//            
//            post = snapshot.value;
//    }];

            FireBaseManager * manager = [FireBaseManager newFBData];
            managerData = manager.userData;
    
//            NSLog(@"%@", managerData[@"user"][@"mail"]);
//            NSLog(@"%@", managerData[@"user"][@"password"]);
    
//            NSString * userName = managerData[@"user"][@"mail"];
//            NSString * userPossword = managerData[@"user"][@"password"];
    
//            NSLog(@"%@", managerData[@"user"][@"mail"]);
//            NSLog(@"%@", managerData[@"user"][@"password"]);

    

}

- (IBAction)cancelButton:(UIButton *)sender {
    //從註冊畫面跳回到登入畫面 2016-09-22
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registeredLogin:(UIButton *)sender {
    
        NSString * usermail = self.registeredViewMail.text;
        NSString * userpassword = self.registeredViewPassword.text;
//    NSString * usercheckpassword = self.registeredViewCheckPassword.text;
    
        for(NSDictionary * key in managerData[@"user"]) {
        
           NSDictionary * test = [managerData[@"user"] objectForKey:key];
            
            if ([test[@"mail"] isEqualToString:@"usermail"] && [test[@"password"] isEqualToString:@"userpassword"]){
            
            NSLog(@"有重複");
            NSLog(@"%@",test[@"user"][@"mail"]);
            NSLog(@"%@",test[@"user"][@"password"]);
                   
//            NSLog(@"帳號密碼重複");
            // 帳號密碼重複跳出警告視窗
            UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"帳號密碼重複" message:@"帳號密碼已有人使用" preferredStyle:UIAlertControllerStyleAlert];
            //準備警告視窗上的按鈕
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
            //將按鈕加到警告視窗上面
            [alertcontroller addAction:ok];
            //將警告視窗呈現在畫面上
            [self presentViewController:alertcontroller animated:YES completion:nil];
                
            } else {
        
            
            // 準備跳到下一頁的物件
            SignInViewController * svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
            
            svc.shoouldDisplyText = usermail;
            // 跳到下一頁
            [self presentViewController:svc animated:YES completion:nil];
            
            NSLog(@"註冊成功，跳到下一頁了");

        }
    }
}
//    if (fireBaseData != nil) {
    
//    for (int i =0 ; i<=post.userDataMail.count ; i++) {
//        
//        mail =  post.userDataMail[i];
//        password = post.userDataPassword[i];
//        NSString *checkPassword = fireBaseData.userDataPassword[i];
//    }



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
