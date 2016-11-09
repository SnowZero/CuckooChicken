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
#import "MatchManager.h"
#import "GameCenterManager.h"
#import "FriendMatchManager.h"


@import Firebase;

@implementation MainCity {
    FIRDatabaseReference *ref;
    NSDictionary *fireData;
    NSTimer *invitationTimer;
    FireBaseManager *userDataManager;
    NSString *roomKey;
    UIAlertController *alertController;
    GameCenterManager *gameCenter;
}



-(void)didMoveToView:(SKView *)view{
//    NSLog(@"sdsdsd");MatchBtn GameCentet Button1 MyFriend
    //[self authPlayer];
    userDataManager = [FireBaseManager newFBData];
    [userDataManager startGetFirebase:_vc:self:false];
    userDataManager.vc = _vc;
    [self startGetUserUID];
    gameCenter = [GameCenterManager new];
    [gameCenter authPlayer:_vc];
    NSLog(@"UID : %@",userDataManager.userUID);
    MatchManager *match = [MatchManager new];
    [self playerNameLabel];
//    [userDataManager setUserName:@"小王"];
//    NSString *name = [userDataManager getUserName:userDataManager.userUID];
//    NSLog(@"dataName: %@",name);
    
    //UI Burron
    SpriteKitButton *matchBtn = [[SpriteKitButton alloc] initWithDefaultButtonImage:@"Button_6.png" activeButtonImage:@"Button_7.png" buttonAction:^{
        //[self MatchButton];
        [match matchButton:_vc :self];
    }];
    SpriteKitButton *gameCenterBtn = [[SpriteKitButton alloc] initWithDefaultButtonImage:@"GameCenter.png" activeButtonImage:@"GameCenter.png" buttonAction:^{
        [gameCenter saveHighscore:userDataManager.score];
        [gameCenter showLeaderBoard:_vc];
    }];
    SpriteKitButton *MyFriendBtn = [[SpriteKitButton alloc] initWithDefaultButtonImage:@"找朋友.png" activeButtonImage:@"找朋友.png" buttonAction:^{
        [_vc showMyFriendTabelView];
        
    }];
    // 第一個輸入要建立的Btn  第二個找畫面上Btn的位置
    [self resetUIPosition:matchBtn :@"MatchBtn"];
    [self resetUIPosition:gameCenterBtn :@"GameCenter"];
    [self resetUIPosition:MyFriendBtn :@"MyFriend"];
    
    // 監控好友邀請


    
}

// 初始化UI位置
-(void)resetUIPosition:(SpriteKitButton*)Button:(NSString*)nodeName{
    [self addChild:Button];
    SKSpriteNode *ButtonPos = (SKSpriteNode*)[self childNodeWithName:nodeName];
    Button.position = ButtonPos.position;
    Button.defaultButton.size = Button.activeButton.size = ButtonPos.size;
    [ButtonPos removeFromParent];
}
-(void)startGetUserUID{
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            userDataManager.userUID = user.uid;
        }else{
            NSLog(@"UID error");
        }
    }];
}

-(void)playerNameLabel {

    SKLabelNode * nameLabel = (SKLabelNode*)[self childNodeWithName:@"playerName"];
//    SKLabelNode * nameLabel = [SKLabelNode labelNodeWithFontNamed:@"playerName"];
    
    // 在Database裡從玩家的UID來尋找要更改名稱的的玩家
    NSString * userIDLabel = [userDataManager getUserName:userDataManager.userUID];
    NSLog(@"玩家的名字:%@",userIDLabel);
    nameLabel.text = userIDLabel;
    
}

-(void)changeTheNameAlertController {

    // 創出一個更改名稱的 alert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更改玩家名稱" message:@"請在下方輸入要更改的名稱" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        // 再加進1個 TextField
        textField.placeholder = @"請輸入ID";
        
    }];
    // 製作確定跟取消的按鈕
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *idField = [[alertController textFields][0] text];
        
        // 加入Timer可以讓ID更新能夠同步
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playerNameLabel) userInfo:nil repeats:NO];
            
        // 在Database裡從玩家的UID來尋找要更改名稱的的玩家，已進行更改名稱
        [userDataManager getUserName:userDataManager.userUID];
        
        // 將更改完的名稱存到Firebase裡的Database裡
        [userDataManager setUserName:idField];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playerNameLabel) userInfo:nil repeats:NO];
        NSLog(@"更改成功");
        
        }];
    
    //將按鈕加到 alert 上面
    [alertController addAction:ok];
    [alertController addAction:cancel];
    //將 alert 呈現在畫面上
    [_vc presentViewController:alertController animated:YES completion:nil];
    
}

// 讓更改名稱按鈕有按下動作的反應
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
    if ([touchedNode.name isEqualToString:@"changeBtn"] || [touchedNode.name isEqualToString:@"changeLabel"]) {
        
        [self changeTheNameAlertController];
        NSLog(@"有按到");
        
    }
}

@end
