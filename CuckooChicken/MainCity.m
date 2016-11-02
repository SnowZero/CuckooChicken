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
    FireBaseManager *userType;
    NSString *roomKey;
    UIAlertController *alertController;
    GameCenterManager *gameCenter;
}



-(void)didMoveToView:(SKView *)view{
//    NSLog(@"sdsdsd");MatchBtn GameCentet Button1
    //[self authPlayer];
    userType = [FireBaseManager newFBData];
    gameCenter = [GameCenterManager new];
    [gameCenter authPlayer:_vc];
    MatchManager *match = [MatchManager new];
    
    //UI Burron
    SpriteKitButton *MatchBtn = [[SpriteKitButton alloc] initWithDefaultButtonImage:@"Button_6.png" activeButtonImage:@"Button_7.png" buttonAction:^{
        //[self MatchButton];
        [match matchButton:_vc :self];
    }];
    SpriteKitButton *GameCenterBtn = [[SpriteKitButton alloc] initWithDefaultButtonImage:@"GameCenter.png" activeButtonImage:@"GameCenter.png" buttonAction:^{
        [gameCenter saveHighscore:userType.score];
        [gameCenter showLeaderBoard:_vc];
    }];
    
    // 第一個輸入要建立的Btn  第二個找畫面上Btn的位置
    [self resetUIPosition:MatchBtn :@"MatchBtn"];
    [self resetUIPosition:GameCenterBtn :@"GameCenter"];
    // 初始化FireBase 取得資料
    //[self startGetFirebase];
}

-(void)resetUIPosition:(SpriteKitButton*)Button:(NSString*)nodeName{
    [self addChild:Button];
    SKSpriteNode *ButtonPos = (SKSpriteNode*)[self childNodeWithName:nodeName];
    Button.position = ButtonPos.position;
    Button.defaultButton.size = Button.activeButton.size = ButtonPos.size;
    [ButtonPos removeFromParent];
}




@end
