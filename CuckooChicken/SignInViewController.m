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
@property (nonatomic, strong) UIImageView *loadingView;            //Loading 動畫使用
@property (weak, nonatomic) IBOutlet UIImageView *showViewBackGroundImage; //登入畫面的背景

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLoadingView]; //啟用動畫 5秒
    [self showViewImage];
}
- (void) showViewImage {
    
    UIImage *image = [UIImage imageNamed:@"viewImage.png"];
    _showViewBackGroundImage.image = image;
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

//Loading 畫面
- (void) setLoadingView {
    
    
    //準備圖片Loading
    NSArray *loadingWords = @[[UIImage imageNamed:@"Loading_1.png"], [UIImage imageNamed:@"Loading_2.png"], [UIImage imageNamed:@"Loading_3.png"], [UIImage imageNamed:@"Loading_4.png"], [UIImage imageNamed:@"Loading_5.png"], [UIImage imageNamed:@"Loading_6.png"], [UIImage imageNamed:@"Loading_7.png"], [UIImage imageNamed:@"Loading_8.png"], [UIImage imageNamed:@"Loading_9.png"], [UIImage imageNamed:@"Loading_10.png"], [UIImage imageNamed:@"Loading_11.png"]];
    
    UIImage *backGround = [UIImage imageNamed:@"Background.png"];//背景
    
    //do loading
    _loadingView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //準備畫面 LoadingView
    CGFloat loatX = (self.view.frame.size.width-300)/2 ;    //LoadingImage X
    CGFloat loatY = self.view.frame.size.height*0.9 ;       //LoadingImage Y
    UIImageView *loadingWordsView = [[UIImageView alloc] initWithFrame:CGRectMake(loatX, loatY, 200, 40)];
    
    [loadingWordsView setAnimationImages:loadingWords]; //將 LoadingView 顯示在畫面
    [loadingWordsView setAnimationDuration:5.0];        //LoadingView 顯示數度
    [loadingWordsView setAnimationRepeatCount:0];       //LoadingView 重複出現
    
    
    [_loadingView setUserInteractionEnabled:true];       //touch事件 預設是 false
    _loadingView.image = backGround;
    _loadingView.tag = 999;                               //tag is UIViewSon 用來當標籤使用
    
    [self.view addSubview:_loadingView];    //顯示在畫面上
    [self.view addSubview:loadingWordsView];//顯示在畫面上
    
    [self changeMouseSuit];
    [loadingWordsView startAnimating];
    [_loadingView startAnimating];
    
    [self performSelector:@selector(stopAnimating:) withObject:_loadingView afterDelay:8.0];
}

//Loading 畫面
- (void) changeMouseSuit {
    //準備動畫圖
    NSArray *mouseBack = @[[UIImage imageNamed:@"character_1.png"],[UIImage imageNamed:@"character_2.png"],[UIImage imageNamed:@"character_3.png"],[UIImage imageNamed:@"character_4.png"],[UIImage imageNamed:@"character_5.png"]];
    
    //準備動畫 規格
    CGFloat floatWidth = self.view.frame.size.height/1.937 ;
    CGFloat floatHeight = self.view.frame.size.height/1.937 ;
    CGFloat floatX = self.view.frame.size.width/2 ;         //主圖中心Ｘ
    CGFloat floatY = self.view.frame.size.height/2 ;
    //主圖中心Ｙ
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, floatWidth, (floatHeight*1.9))];
    
    backgroundView.center = CGPointMake(floatX, floatY);
    
    UIImageView *mouse = [UIImageView new];
    
    float mouseWidth = backgroundView.frame.size.width ;
    float mouseHeight = backgroundView.frame.size.height ;
    
    mouse.frame = CGRectMake(0, 0, mouseWidth, mouseHeight);
    
    [mouse setAnimationImages:mouseBack];
    [mouse setAnimationDuration:6];
    [mouse setAnimationRepeatCount:0];
    
    [self.view addSubview:backgroundView];  //將拿到使用者的畫面的中心，顯示在畫面上。
    
    [backgroundView addSubview:mouse];
    
    backgroundView.tag = 999;
    
    [mouse startAnimating];
    
}

//停止Loading 畫面
- (void) stopAnimating:(UIImageView*)sender {
    
    for (UIView *viewSon in self.view.subviews) {
        if (viewSon.tag == 999) {
            [viewSon removeFromSuperview];           //停止顯示子示圖，並從父示圖中移除
        } else if ([viewSon isKindOfClass:[UIImageView class]]){
            //檢測viewSon 是UIImageView 的子類別
            [(UIImageView*)viewSon stopAnimating];  //不是就停止動畫
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
