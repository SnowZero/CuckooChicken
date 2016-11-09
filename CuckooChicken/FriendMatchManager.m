//
//  FriendMatchManager.m
//  CuckooChicken
//
//  Created by Snos on 2016/11/7.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "FriendMatchManager.h"

#import "FireBaseManager.h"
#import "GameScene.h"

@import Firebase;

@implementation FriendMatchManager{
    
    NSDictionary *fireData;
    NSTimer *timer;
    FireBaseManager *userType;
    NSString *roomKey;
    UIAlertController *alertController;
    UIViewController *vc;
    SKScene *mainScene;
    NSString *friendUID;
    
}

- (void)startGetFirebase{
    
    FIRDatabaseReference *ref;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        fireData = snapshot.value;
    }];
    
}

-(void)matchButton:(UIViewController*)myVc:(SKScene*)myScene:(NSString*)myFriendUID{
    userType = [FireBaseManager newFBData];
    [self startGetFirebase];
    vc = myVc;
    friendUID = myFriendUID;
    userType.enemyUID = myFriendUID;
    mainScene = myScene;
    //Wait for the connection
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkGetData2) userInfo:nil repeats:true];
    
    alertController = [UIAlertController alertControllerWithTitle:@"等待連接中..." message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self cancelConnection];
    }];
    
    [alertController addAction:cancelAction];
    //把Alert對話框顯示出來
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
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
    [self cancelInvitation];

}
-(void)cancelInvitation{
    FIRDatabaseReference *ref2;
    NSString *strUrl2 = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    ref2 = [[FIRDatabase database] referenceFromURL:strUrl2];
    ref2 = [[ref2 child:@"user"] child:friendUID];
    ref2 = [[ref2 child:@"Invitation"] child:roomKey];
    [ref2 removeValue];
}

//偵測是否取得資料 Check data
-(void)checkGetData2{
    // Check fireData
    if (fireData) {
        //close Timer
        [timer invalidate];
        timer = nil;
        [self connectionStart];
    }
}

-(void)connectionStart{
    //檢測房間有無位置 Check Room

        //create room
    [self createRoomWithMaster];
    
    
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
    NSDictionary *data = @{@"staySum":@"3",@"host":userType.userUID};
    [ref setValue:data];
    
    // Check Number of people
    NSTimer *timer= [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkCout:) userInfo:roomKey repeats:true];
    [self setInvitationCard];
}
// 送出邀請函
-(void)setInvitationCard{
    FIRDatabaseReference *ref;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    ref = [[ref child:@"user"] child:friendUID];
    ref = [[ref child:@"Invitation"] child:roomKey];
    [ref setValue:@{@"staySum":@"1"}];
}
//檢查是否找到對手
-(void)checkCout:(NSTimer*)timer{
    NSString *key = timer.userInfo;
    NSDictionary *tmp = fireData[@"user"][friendUID][@"Invitation"][roomKey];
    if ([tmp[@"staySum"] intValue] >=2 ) {
        [timer invalidate];
        timer = nil;
        userType.playerType = PLAYER_TYPE_ATTACK;
        userType.enemyType = PLAYER_TYPE_DEFENSE;
        userType.gameRoomKey = key;
        
        [self gotoGameViewController];
        userType.enemyUID = tmp[@"guest"];
        
    }
    //close Timer
    
}

//加入房間為客戶
-(void)joinToRoomWithClient:(NSString*)thisRoom:(UIViewController*)myVc:(SKScene*)myScene:(bool)isTabelView{
    userType = [FireBaseManager newFBData];

    FIRDatabaseReference *ref;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    ref = [ref child:@"GameRoom"];
    ref  = [ref child:thisRoom];

    [[ref child:@"staySum"] setValue:@"4"];
    [[ref child:@"guest"] setValue:userType.userUID];
    
    FIRDatabaseReference *ref2;
    ref2 = [[FIRDatabase database] referenceFromURL:strUrl];
    ref2 = [ref2 child:@"user"];
    ref2 = [ref2 child:userType.userUID];
    ref2 = [ref2 child:@"Invitation"];
    ref2  = [ref2 child:thisRoom];
    
    
    
    
    userType.playerType = PLAYER_TYPE_DEFENSE;
    userType.enemyType = PLAYER_TYPE_ATTACK;
    userType.gameRoomKey = thisRoom;
    userType.enemyUID = fireData[@"GameRoom"][thisRoom][@"host"];
    
    
    vc = myVc;
    mainScene = myScene;
    alertController = [UIAlertController alertControllerWithTitle:@"好友邀請您連線，要接受嗎？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isTabelView == true) {
            [vc dismissViewControllerAnimated:true completion:nil];
        }
        [[ref2 child:@"staySum"] setValue:@"2"];
        [self joinGotoGameViewController];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:ok];
    //把Alert對話框顯示出來
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
    
}

-(void)joinGotoGameViewController{
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.vc = vc;
        // Present the scene.
        //        [mainScene.view presentScene:scene];
        //        [vc dismissViewControllerAnimated:true completion:nil];

        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIView *topView = window.rootViewController.view;
        [mainScene.view presentScene:scene];
        //[window.rootViewController dismissViewControllerAnimated:true completion:nil];
        //[self cancelInvitation];

    
}

-(void)gotoGameViewController{
    [alertController dismissViewControllerAnimated:NO completion:^{
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.vc = vc;
        // Present the scene.
//        [mainScene.view presentScene:scene];
//        [vc dismissViewControllerAnimated:true completion:nil];
        [mainScene.view presentScene:scene];
        [vc dismissViewControllerAnimated:true completion:nil];
        [self cancelInvitation];
    }];
    
}

@end
