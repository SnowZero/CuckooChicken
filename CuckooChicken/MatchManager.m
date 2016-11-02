//
//  MatchManager.m
//  CuckooChicken
//
//  Created by Snos on 2016/11/2.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "MatchManager.h"
#import "FireBaseManager.h"
#import "GameScene.h"

@import Firebase;

@implementation MatchManager{

    NSDictionary *fireData;
    NSTimer *timer;
    FireBaseManager *userType;
    NSString *roomKey;
    UIAlertController *alertController;
    GameViewController *vc;
    SKScene *mainScene;

}

- (void)startGetFirebase{
    
    FIRDatabaseReference *ref;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        fireData = snapshot.value;
    }];
    
}

-(void)matchButton:(GameViewController*)myVc:(SKScene*)myScene{
    userType = [FireBaseManager newFBData];
    [self startGetFirebase];
    vc = myVc;
    mainScene = myScene;
    //Wait for the connection
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkGetData) userInfo:nil repeats:true];
    
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
        userType.enemyType = PLAYER_TYPE_DEFENSE;
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
    userType.enemyType = PLAYER_TYPE_ATTACK;
    userType.gameRoomKey = thisRoom;
    [self gotoGameViewController];
}

-(void)gotoGameViewController{
    [alertController dismissViewControllerAnimated:NO completion:^{
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.vc = vc;
        // Present the scene.
        [mainScene.view presentScene:scene];
    }];
    
    
    
}

@end
