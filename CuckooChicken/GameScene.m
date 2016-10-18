//
//  GameScene.m
//  CuckooChicken
//
//  Created by Snos on 2016/9/12.
//  Copyright (c) 2016年 Snow. All rights reserved.
//

#import "GameScene.h"
#import "Player.h"
#import "FireBaseManager.h"
@import Firebase;

@implementation GameScene{
    Player *player;
    Player *enemy;
}

-(void)didMoveToView:(SKView *)view {
    
    
   /* Setup your scene here */
    player = [Player new];
    player = [player newPlayer:0.5];
    [player setAnimation:@"eagle_back" myPlayer:player];
    player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/6);
    [self addChild:player];
    
    enemy = [Player new];
    enemy = [player newPlayer:0.5];
    [player setAnimation:@"egg" myPlayer:enemy];
    enemy.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/4);
    [self addChild:enemy];
    
//    FIRDatabaseReference *ref;
//    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
//    ref = [[FIRDatabase database] referenceFromURL:strUrl];
//    __block NSDictionary *post;
//    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        post = snapshot.value;
//        NSLog(@"%@", post[@"condition"]);
//    }];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

// Player Move
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        player.position = CGPointMake(location.x, player.position.y);
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
