//
//  GameScene.m
//  CuckooChicken
//
//  Created by Snos on 2016/9/12.
//  Copyright (c) 2016年 Snow. All rights reserved.
//

#import "GameScene.h"
#import "Player.h"

@implementation GameScene{
    Player *player;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    player = [Player newPlayer:0.5];
    player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/6);
    [self addChild:player];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {

    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
