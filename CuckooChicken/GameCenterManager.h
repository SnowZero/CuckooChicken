//
//  GameCenterManager.h
//  CuckooChicken
//
//  Created by Snos on 2016/10/29.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"
#import <GameKit/GameKit.h>

@interface GameCenterManager : NSObject<GKGameCenterControllerDelegate>

-(void)authPlayer:(GameViewController*)thisVC;
-(void)saveHighscore:(int)number;
-(void)showLeaderBoard:(GameViewController*)thisVC;
@end
