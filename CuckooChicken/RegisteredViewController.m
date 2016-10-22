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


@property (weak, nonatomic) IBOutlet UITextField *registeredViewMail;
@property (weak, nonatomic) IBOutlet UITextField *registeredViewPassword;


@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)cancelButton:(UIButton *)sender {
    //從註冊畫面跳回到登入畫面 2016-09-22
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registeredLogin:(UIButton *)sender {
    
    NSString *usermail = _registeredViewMail.text;
    NSString *userpassword = _registeredViewPassword.text;
    
    // 在FireBase上比對使用者輸入的mail跟password是否有重複 2016-10-22
    [[FIRAuth auth] createUserWithEmail:usermail password:userpassword completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        // 有重複在這裡執行
        if (error){
            // 帳號密碼重複跳出 alert
            UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"⚠️電子信箱密碼重複⚠️" message:@"電子信箱密碼已有人使用" preferredStyle:UIAlertControllerStyleAlert];
            //準備 alert 上的按鈕
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
            //將按鈕加到 alert 上面
            [alertcontroller addAction:ok];
            //將 alert 呈現在畫面上
            [self presentViewController:alertcontroller animated:YES completion:nil];

            NSLog(@"signedUp error = %@", error.localizedDescription);
            return;
        }
        // 沒有重複在這裡執行
        // 跳出帳號密碼註冊成功 alert
        UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"註冊成功🎉" message:@"現在可以開始進入遊戲了❗️❗️😆😆" preferredStyle:UIAlertControllerStyleAlert];
        //準備 alert 上的按鈕
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * ok) {
        
        // 準備跳到下一頁的物件
        SignInViewController * svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInView"];
        svc.shoouldDisplyText = usermail;
        // 跳到下一頁
        [self presentViewController:svc animated:YES completion:nil];
        
        }];
        
        //將按鈕加到訊息框上面
        [alertcontroller addAction:ok];
        //將訊息框呈現在畫面上
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
        NSLog(@"註冊成功，跳到下一頁了");
//        [self setDisplayName:user];
    }];

}

//- (void)setDisplayName:(FIRUser *)user {
//    FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
//    // Use first part of email as the default display name
//    changeRequest.displayName = [[user.email componentsSeparatedByString:@"@"] objectAtIndex:0];
//    [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
//        if (error){
//            NSLog(@"%@", error.localizedDescription);
//            return;
//        }
//        [self signedIn:[FIRAuth auth].currentUser];
//    }];
//    
//    NSLog(@" user == %@", changeRequest.displayName);
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
//    // 下面輸入轉場的code
//}

// 使用者登入方法
//- (IBAction)test:(id)sender {
//
//
//                         [self signedIn:user];
//                         
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
