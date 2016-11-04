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

@import Firebase;

@implementation MainCity {
    NSDictionary *fireData;
    NSTimer *timer;
    FireBaseManager *userDataManager;
    NSString *roomKey;
    UIAlertController *alertController;
    GameCenterManager *gameCenter;
}



-(void)didMoveToView:(SKView *)view{
//    NSLog(@"sdsdsd");MatchBtn GameCentet Button1 MyFriend
    //[self authPlayer];
    userDataManager = [FireBaseManager newFBData];
    [userDataManager startGetFirebase];
    gameCenter = [GameCenterManager new];
    [gameCenter authPlayer:_vc];
    MatchManager *match = [MatchManager new];
    [userDataManager setUserName:@"小明"];
    NSString *name = [userDataManager getUserName:userDataManager.userUID];
    NSLog(@"dataName: %@",name);
    
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

}
// 初始化UI位置
-(void)resetUIPosition:(SpriteKitButton*)Button:(NSString*)nodeName{
    [self addChild:Button];
    SKSpriteNode *ButtonPos = (SKSpriteNode*)[self childNodeWithName:nodeName];
    Button.position = ButtonPos.position;
    Button.defaultButton.size = Button.activeButton.size = ButtonPos.size;
    [ButtonPos removeFromParent];
}



@end
