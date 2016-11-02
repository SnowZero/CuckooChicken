//
//  MainCity.m
//  CuckooChicken
//
//  Created by Snos on 2016/11/2.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "MainCity.h"
#import "CuckooChicken-Swift.h"
#import "FireBaseManager.h"
#import "GameScene.h"

@import Firebase;

@implementation MainCity {
    NSDictionary *fireData;
    NSTimer *timer;
    FireBaseManager *userType;
    NSString *roomKey;
    UIViewController *vc;
}



-(void)didMoveToView:(SKView *)view{
//    NSLog(@"sdsdsd");MatchBtn GameCentet
    //[self authPlayer];
    vc = self.view.window.rootViewController;
    userType = [FireBaseManager newFBData];
    [self authPlayer];
    vc = self.view.window.rootViewController;
    //UI Burron
    SpriteKitButton *MatchBtn = [[SpriteKitButton alloc] initWithDefaultButtonImage:@"Button_6.png" activeButtonImage:@"Button_7.png" buttonAction:^{
        [self MatchButton];
    }];
    SpriteKitButton *GameCenterBtn = [[SpriteKitButton alloc] initWithDefaultButtonImage:@"GameCenter.png" activeButtonImage:@"GameCenter.png" buttonAction:^{
        [self saveHighscore:userType.score];
        [self showLeaderBoard];
    }];
    [self resetUIPosition:MatchBtn :@"MatchBtn"];
    [self resetUIPosition:GameCenterBtn :@"GameCenter"];
    [self startGetFirebase];
}

-(void)resetUIPosition:(SpriteKitButton*)Button:(NSString*)nodeName{
    [self addChild:Button];
    SKSpriteNode *ButtonPos = (SKSpriteNode*)[self childNodeWithName:nodeName];
    Button.position = ButtonPos.position;
    Button.defaultButton.size = Button.activeButton.size = ButtonPos.size;
    [ButtonPos removeFromParent];
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
-(void)MatchButton{
    //Wait for the connection
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkGetData) userInfo:nil repeats:true];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"等待連接中..." message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self cancelConnection];
    }];
    
    [alertController addAction:cancelAction];
    //把Alert對話框顯示出來
    vc = self.view.window.rootViewController;
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
    [vc dismissViewControllerAnimated:NO completion:^{
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:scene];
    }];
}

-(void)authPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [vc presentViewController:viewController animated:true completion:nil];
        }else{
            NSLog(@"%d",[[GKLocalPlayer localPlayer] isAuthenticated]);
        }
    };
    [self saveHighscore:userType.score];
}

-(void)saveHighscore:(NSInteger)number{
    if (userType.score) {
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            GKScore* scoreRepoter =[[GKScore alloc] initWithLeaderboardIdentifier:@"Score"];
            scoreRepoter.value = number;
            NSArray *scoreArray = @[scoreRepoter];
            [GKScore reportScores:scoreArray withCompletionHandler:nil];
        }
    }
}

-(void)showLeaderBoard{
    GKGameCenterViewController *gvc = [GKGameCenterViewController new];
    gvc.gameCenterDelegate = self;
    UIViewController *vc2 = self.view.window.rootViewController;
    [vc2 presentViewController:gvc animated:true completion:nil];
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:true completion:nil];
}



@end
