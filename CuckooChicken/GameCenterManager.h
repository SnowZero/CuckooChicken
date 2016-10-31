//
//  GameCenterManager.h
//  CuckooChicken
//
//  Created by Snos on 2016/10/29.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterManager : NSObject

-(void)authPlayer:(UIViewController*)thisVC;
-(void)saveHighscore:(int)number;
-(void)showLeaderBoard:(UIViewController*)thisVC;
@end
