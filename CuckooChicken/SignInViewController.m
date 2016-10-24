//
//  SignInViewController.m
//  CuckooChicken
//
//  Created by 魏凡皓 on 2016/9/20.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "SignInViewController.h"
#import "FireBaseManager.h"

@import Firebase;

@interface SignInViewController ()
{
//    FIRDatabaseReference *ref;
}
@property (weak, nonatomic) IBOutlet UITextField *gameForMail;
@property (weak, nonatomic) IBOutlet UITextField *gamePassword;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)gameSianIn:(UIButton *)sender {

    NSString * sianInMail = self.gameForMail.text;
    NSString * aianInPassword = self.gamePassword.text;
    
    // 在 FireBase 上比對使用者輸入的 mail 跟 password 是否有重複 2016-10-22
        [[FIRAuth auth] signInWithEmail:sianInMail
                               password:aianInPassword
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        // mail password 輸入錯誤就執行這
        if (error){
            
        //  創出 alert
        UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"⚠️電子信箱密碼錯誤⚠️" message:@"請重新輸入電子信箱跟密碼" preferredStyle:UIAlertControllerStyleAlert];
        // 準備創出 alert 上的按鈕
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
            
        // 將按鈕加到創出 alert 上面
        [alertcontroller addAction:ok];
        
        // 將 alert 現在畫面上
        [self presentViewController:alertcontroller animated:YES completion:nil];
    
        NSLog(@"signIn error = %@", error.localizedDescription);
        return ;
            
        // mail 跟 password 沒有輸入值的話就在這執行
        } else if (aianInPassword == nil) {
        
            // 創出 alert
            UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"⚠️沒有輸入電子信箱⚠️" message:@"請輸入電子信箱跟密碼" preferredStyle:UIAlertControllerStyleAlert];
            // 準備 alert 上的按鈕
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
            
            // 將按鈕加到 alert 上面
            [alertcontroller addAction:ok];
            
            //將 alert 呈現在畫面上
            [self presentViewController:alertcontroller animated:YES completion:nil];
            
            NSLog(@"signIn error = %@", error.localizedDescription);
        }
        
        // 輸入成功就進入遊戲
        // 準備跳到下一頁的物件
        MatchPlayersViewController * mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchVC"];
        mvc.goToMVC = sianInMail;
        // 跳到下一頁
        [self presentViewController:mvc animated:YES completion:nil];
        NSLog(@"成功進入遊戲");
        
        }];
}

- (IBAction)forgetPassword:(UIButton *)sender {
    
    
    // 先做出一個Alert 2016-09-22
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"❓忘記密碼❓" message:@"請輸入Mail，系統會發送信件讓您重新設定密碼" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        // 再加進1個 TextField
        textField.placeholder = @"Mail";
        
            
        }];
    
    //做出"確定"跟"取消"的按鈕 2016-09-22
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * ok) {
        
        NSString *email = [[alertController textFields][0] text];
        
        [[FIRAuth auth] sendPasswordResetWithEmail:email
                                        completion:^(NSError *_Nullable error) {
        // 輸入錯誤就執行這
        if (error) {
        
            // 電子郵件輸入錯誤跳出 alert
            UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"⚠️電子信箱輸入錯誤⚠️" message:@"請重新輸入" preferredStyle:UIAlertControllerStyleAlert];
            //準備 alert 上的按鈕
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
            //將按鈕加到 alert 上面
            [alertcontroller addAction:ok];
            //將 alert 呈現在畫面上
            [self presentViewController:alertcontroller animated:YES completion:nil];
            
                // 輸入成功就執行這
                } else {
                
                    // 跳出發送重設密碼電子郵件的 alert
               UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"電子郵件已送出" message:@"請至信箱確認" preferredStyle:UIAlertControllerStyleAlert];
               //準備 alert 上的按鈕
               UIAlertAction * ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
               //將按鈕加到 alert 上面
               [alertcontroller addAction:ok];
               //將 alert 呈現在畫面上
               [self presentViewController:alertcontroller animated:YES completion:nil];
                }
        }];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:ok];
    //把 Alert 對話框顯示出來 2016-09-22
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backToMain:(UIStoryboardSegue*)sender {
    
    NSLog(@"backToMain storyboard.");
    
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
