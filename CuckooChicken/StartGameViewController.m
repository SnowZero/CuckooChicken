//
//  StartGameViewController.m
//  CuckooChicken
//
//  Created by Snos on 2016/11/1.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "StartGameViewController.h"
#import "FireBaseManager.h"
#import "SignInViewController.h"

@import Firebase;

@interface StartGameViewController ()
{
    FireBaseManager *userDataManager;
    NSTimer *finishTimer;
}

@end

@implementation StartGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userDataManager = [FireBaseManager newFBData];
    [userDataManager startGetFirebase];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startGameBtn:(id)sender {
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            NSLog(@"使用者以登入，UID為: %@",user.uid);
            userDataManager.userUID = user.uid;
            finishTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkDataFinish:) userInfo:nil repeats:true];
            
        } else {
            // No user is signed in.
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您還未登入喔，請登入才可進行遊戲。" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"瞭解" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                UIViewController * mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInView"];
                // 跳到下一頁
                    finishTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkLoginDataFinish:) userInfo:nil repeats:true];            }];
            
            [alertController addAction:cancelAction];
            //把Alert對話框顯示出來
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
-(void)checkDataFinish:(NSTimer*)timer{
    if ([userDataManager askUserDataFinish]) {
        [timer invalidate];
        timer = nil;
        [self goToMainCity:@"MatchVC"];
    }
}
-(void)checkLoginDataFinish:(NSTimer*)timer{
    if ([userDataManager askUserDataFinish]) {
        [timer invalidate];
        timer = nil;
        [self goToMainCity:@"SignInView"];
    }
}
-(void)goToMainCity:(NSString*)vcID{
    UIViewController * mvc = [self.storyboard instantiateViewControllerWithIdentifier:vcID];
    // 跳到下一頁
    [self presentViewController:mvc animated:YES completion:nil];
}


- (IBAction)loginBtn:(id)sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"登出成功");
    }
    finishTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkLoginDataFinish:) userInfo:nil repeats:true];
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
