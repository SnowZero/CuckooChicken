//
//  MainCity.h
//  CuckooChicken
//
//  Created by Snos on 2016/11/2.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"
#import <GameKit/GameKit.h>
@interface MainCity : SKScene<GKGameCenterControllerDelegate>
@property(strong,nonnull) GameViewController *vc;

@end
