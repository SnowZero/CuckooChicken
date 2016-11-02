//
//  GameScene.h
//  CuckooChicken
//

//  Copyright (c) 2016年 Snow. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"

@interface GameScene : SKScene<SKPhysicsContactDelegate>
@property(strong,nonnull)GameViewController *vc;

@end
