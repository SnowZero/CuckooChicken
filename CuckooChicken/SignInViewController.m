//
//  SignInViewController.m
//  CuckooChicken
//
//  Created by 魏凡皓 on 2016/9/20.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)gameIdNumber:(UITextField *)sender {
}
- (IBAction)gamePassword:(UITextField *)sender {
}
- (IBAction)gameSianIn:(UIButton *)sender {
}
- (IBAction)forgetPassword:(UIButton *)sender {
    //做出一個Alert對話框，先做出2個訊息框 2016-09-22
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"忘記密碼" message:@"請輸入帳號跟Mail" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"帳號";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Mail";
        textField.secureTextEntry = YES;
    }];
    //做出"確定"跟"取消"的按鈕 2016-09-22
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    //把Alert對話框顯示出來 2016-09-22
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backToMain:(UIStoryboardSegue*)sender {
    
    NSLog(@"backToMain executed.");
    
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
