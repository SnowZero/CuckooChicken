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
#import "AppState.h"
#import "Constants.h"
#import "MeasurementHelper.h"

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
    FireBaseManager * manager = [FireBaseManager newFBData];
    managerData = manager.userData;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)cancelButton:(UIButton *)sender {
    //從註冊畫面跳回到登入畫面 2016-09-22
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registeredLogin:(UIButton *)sender {
    
        NSString * usermail = self.registeredViewMail.text;
        NSString * userpassword = self.registeredViewPassword.text;
//    NSString * usercheckpassword = self.registeredViewCheckPassword.text;
//        NSLog(@"usermail=%@",usermail);
    
        for(NSDictionary * key in managerData[@"user"]) {
        
           NSDictionary * test = [managerData[@"user"] objectForKey:key];
            NSString *mail = [NSString stringWithFormat:@"%@",test[@"mail"]];
            NSString *password = [NSString stringWithFormat:@"%@",test[@"password"]];
            
            if ([mail isEqualToString:usermail] && [password isEqualToString:userpassword]) {
            
            NSLog(@"帳號密碼重複");
            NSLog(@"%@",test[@"mail"]);
            NSLog(@"%@",test[@"password"]);
    
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
            SignInViewController * svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInView"];
            
            svc.shoouldDisplyText = usermail;
            // 跳到下一頁
            [self presentViewController:svc animated:YES completion:nil];
            
            NSLog(@"註冊成功，跳到下一頁了");
              
        }
    }
}

//- (IBAction)test:(id)sender {
//
//    // Sign In with credentials
//    NSString *email = _registeredViewMail.text;
//    NSString *password = _registeredViewPassword.text;
//    [[FIRAuth auth] signInWithEmail:email
//                           password:password
//                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//                             if (error){
//                                 NSLog(@"signIn error = %@", error.localizedDescription);
//                                 
//                                 NSLog(@"Lynn signIn error = %@", error.userInfo);
//                                 return ;
//                             }
//                             [self signedIn:user];
//                         }];
//}
//
//- (void)signedIn:(FIRUser *)user {
//    [MeasurementHelper sendLoginEvent];
//    
//    [AppState sharedInstance].displayName = user.displayName.length > 0 ? user.displayName :user.email;
//    [AppState sharedInstance].photoUrl = user.photoURL;
//    [AppState sharedInstance].signedIn = YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationKeysSignedIn
//                                                        object:nil userInfo:nil];
//    [self performSegueWithIdentifier:SeguesSignInToAv sender:nil];
//}


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
