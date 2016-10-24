//
//  MatchPlayersViewController.m
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "MatchPlayersViewController.h"
#import "FireBaseManager.h"
#import "ViewController.h"
@import Firebase;

@interface MatchPlayersViewController (){
    NSDictionary *fireData;
    NSTimer *timer;
    FireBaseManager *userType;
    NSString *roomKey;
}
@property (nonatomic, strong) UIImageView *loadingViewForChange; //載入動畫 5秒
@end

@implementation MatchPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self changeBackGroundView];
    
    userType = [FireBaseManager newFBData];
    [[FIRAuth auth] signInWithEmail:@"snow@gmail.com"
                           password:@"s123456"
                         completion:^(FIRUser *user, NSError *error) {
       if (error) {
            NSLog(@"error");
           return;
       }
        NSString *udid = user.uid;
        NSLog(@"UDID是 ：%@",user.uid);
    }];
    
    [self startGetFirebase];

}

// Start connect Firebase
- (void)startGetFirebase{
    
    FIRDatabaseReference *ref;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        fireData = snapshot.value;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)MatchButton:(id)sender {
    //Wait for the connection
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkGetData) userInfo:nil repeats:true];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"等待連接中..." message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self cancelConnection];
    }];

    [alertController addAction:cancelAction];
    //把Alert對話框顯示出來
    [self presentViewController:alertController animated:YES completion:nil];




}
//偵測是否取得資料 Check data
-(void)checkGetData{
    // Check fireData
    if (fireData) {
        //close Timer
        [timer invalidate];
        timer = nil;
        [self connectionStart];
    }
}

-(void)cancelConnection{
    [timer invalidate];
    timer = nil;
    if (roomKey) {
        FIRDatabaseReference *ref;
        NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
        ref = [[FIRDatabase database] referenceFromURL:strUrl];
        ref = [[ref child:@"GameRoom"] child:roomKey];
        [ref removeValue];
    }
}

-(void)connectionStart{
    //檢測房間有無位置 Check Room
    if (fireData[@"GameRoom"] == nil) {
        [self createRoomWithMaster];
    }else{
        for (NSDictionary *key in fireData[@"GameRoom"]) {
            NSDictionary * tmp = [fireData[@"GameRoom"] objectForKey:key];
            
            if ([tmp[@"staySum"] intValue] < 2) {
                roomKey = [NSString stringWithFormat:@"%@",key];
                [self joinToRoomWithClient:roomKey];
                return;
            }
        }
        //create room
        [self createRoomWithMaster];
        return;
    }
    
}

//建立房間為房主 Homeowners
-(void)createRoomWithMaster{
    FIRDatabaseReference *ref;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    ref = [[FIRDatabase database] referenceFromURL:strUrl];

    ref = [ref child:@"GameRoom"];
    // childByAutoId 自動生成不重複的亂數ID
    roomKey = [ref childByAutoId].key;
    ref  = [ref child:roomKey];
    NSDictionary *data = @{@"staySum":@"1"};
    [ref setValue:data];
    
    // Check Number of people
    NSTimer *timer= [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkCout:) userInfo:roomKey repeats:true];
}
//檢查是否找到對手
-(void)checkCout:(NSTimer*)timer{
    NSString *key = timer.userInfo;
    NSDictionary *tmp = fireData[@"GameRoom"][key];
    if ([tmp[@"staySum"] intValue] >=2 ) {
        [timer invalidate];
        timer = nil;
        userType.playerType = PLAYER_TYPE_ATTACK;
        userType.gameRoomKey = key;
        [self gotoGameViewController];

    }
        //close Timer

}

//加入房間為客戶
-(void)joinToRoomWithClient:(NSString*)thisRoom{
    FIRDatabaseReference *ref;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    ref = [[FIRDatabase database] referenceFromURL:strUrl];

    NSDictionary *upData = @{@"staySum":@"2"};
    NSDictionary *childUpdates = @{[@"/GameRoom/" stringByAppendingString:thisRoom]:upData};
    [ref updateChildValues:childUpdates];
    userType.playerType = PLAYER_TYPE_DEFENSE;
    userType.gameRoomKey = thisRoom;
    [self gotoGameViewController];
}

-(void)gotoGameViewController{
    [self dismissViewControllerAnimated:NO completion:^{
        ViewController * svc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameVC"];
        // 跳到下一頁
        [self presentViewController:svc animated:YES completion:nil];
    }];

}
//Loading 畫面
- (void) changeBackGroundView {
    NSArray *loadingWords = @[[UIImage imageNamed:@"Loading_1.png"], [UIImage imageNamed:@"Loading_2.png"], [UIImage imageNamed:@"Loading_3.png"], [UIImage imageNamed:@"Loading_4.png"], [UIImage imageNamed:@"Loading_5.png"], [UIImage imageNamed:@"Loading_6.png"], [UIImage imageNamed:@"Loading_7.png"], [UIImage imageNamed:@"Loading_8.png"], [UIImage imageNamed:@"Loading_9.png"], [UIImage imageNamed:@"Loading_10.png"], [UIImage imageNamed:@"Loading_11.png"]];
    //換場的圖
    NSArray *changeImage = @[[UIImage imageNamed:@"turn_1.png"], [UIImage imageNamed:@"turn_2.png"]];
    //換場背景
    UIImage *changeBackGroundView = [UIImage imageNamed:@"turnBackground_1.png"];
    //準備畫面 LoadingView
    _loadingViewForChange = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_loadingViewForChange setUserInteractionEnabled:true];       //touch事件 預設是 false
    _loadingViewForChange.image = changeBackGroundView;
    [self.view addSubview:_loadingViewForChange];
    
    CGFloat loatX = (self.view.frame.size.width-300)/2 ;    //LoadingImage X
    CGFloat loatY = self.view.frame.size.height*0.9 ;       //LoadingImage Y
    UIImageView *bbbb  = [[UIImageView alloc] initWithFrame:CGRectMake(loatX, loatY, 200, 40)];
    
    [bbbb setAnimationImages:loadingWords]; //將 LoadingView 顯示在畫面
    [bbbb setAnimationDuration:5.0];        //LoadingView 顯示數度
    [bbbb setAnimationRepeatCount:0];       //LoadingView 重複出現
    [self.view addSubview:bbbb];
    [bbbb startAnimating];
    
    CGFloat floatWidth = self.view.frame.size.height/1.937 ;
    CGFloat floatHeight = self.view.frame.size.height/1.937 ;
    
    UIImageView *changesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4.5, self.view.frame.size.height*0.25, (floatWidth*0.6),(floatHeight*0.5))];
    
    [changesImageView setAnimationImages:changeImage];
    [changesImageView setAnimationDuration:2.0];
    [changesImageView setAnimationRepeatCount:0];
    
    [self.view addSubview:changesImageView];    //顯示在畫面上
    _loadingViewForChange.tag = 999;
    [changesImageView startAnimating];
    
    [self performSelector:@selector(stopAnimating:) withObject:_loadingViewForChange afterDelay:5.0];
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




@end
