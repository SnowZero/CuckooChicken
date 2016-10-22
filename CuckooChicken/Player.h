//
//  Player.h
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FireBaseManager.h"

#define EAGLE_Animation @"eagle"
#define EGG_Animation @"egg"

@interface Player : SKSpriteNode

- (Player*) newPlayer:(float)mySize;
- (void) setAnimation:(NSString*)animationKey
             myPlayer:(SKSpriteNode*)myPlayer;

@end
