//
//  RegisteredViewController.m
//  
//
//  Created by 魏凡皓 on 2016/9/20.
//
//

#import "RegisteredViewController.h"
#import "ViewController.h"
#import "FireBaseDataController.h"

@import Firebase;
@interface RegisteredViewController ()
@property (weak, nonatomic) IBOutlet UITextField *registeredViewMail;
@property (weak, nonatomic) IBOutlet UITextField *registeredViewPassword;
@property (weak, nonatomic) IBOutlet UITextField *registeredViewCheckPassword;


@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButton:(UIButton *)sender {
    //從註冊畫面跳回到登入畫面 2016-09-22
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registeredLogin:(UIButton *)sender {
    NSString * usermail = self.registeredViewMail.text;
    NSString * userpassword = self.registeredViewPassword.text;
    NSString * usercheckpassword = self.registeredViewCheckPassword.text;
    
    FireBaseDataController *fireBaseData = [FireBaseDataController new];
//
//    [self fireBaseData.setupRemoteConfig];

//    if([usermail isEqualToString:@"userDataMail"] &&
//       [userpassword isEqualToString:@"userDataPassword"] &&
//       [usercheckpassword isEqualToString:@"userDataPassword"]) {
//        NSLog(@"帳號密碼正確");
    for (int i =0 ; i<=fireBaseData.userDataMail.count ; i++) {
        
        NSString *mail =  fireBaseData.userDataMail[i];
        NSString *password = fireBaseData.userDataPassword[i];
        
        if([usermail isEqualToString:(mail) ] && [userpassword isEqualToString:(password)]) {
            // cotains  key
            NSLog(@"帳號密碼正確");
            // 準備跳到下一頁的物件
            SignInViewController * rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
            
            rvc.shoouldDisplyText = usermail;
            // 跳到下一頁
            [self presentViewController:rvc animated:YES completion:nil];
            
        } else {
            NSLog(@"帳號密碼重複");
            // 帳號密碼重複跳出警告視窗
            UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"帳號密碼重複" message:@"帳號密碼已有人使用" preferredStyle:UIAlertControllerStyleAlert];
            //準備警告視窗上的按鈕
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
            //將按鈕加到警告視窗上面
            [alertcontroller addAction:ok];
            //將警告視窗呈現在畫面上
            [self presentViewController:alertcontroller animated:YES completion:nil];
        }
    }
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
