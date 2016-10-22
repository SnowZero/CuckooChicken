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
    FireBaseManager *userData;
    FIRDatabaseReference *ref;
    __block NSDictionary *fireData;

}

-(void)didMoveToView:(SKView *)view {
    userData = [FireBaseManager newFBData];
    [self startFirebase];
    
   /* Setup your scene here */
    player = [Player new];
    player = [player newPlayer:0.5];
    player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/6);

    
    enemy = [Player new];
    enemy = [player newPlayer:0.5];
    if ([userData.playerType isEqualToString:PLAYER_TYPE_ATTACK]) {
        [player setAnimation:EAGLE_Animation myPlayer:player];
        [player setAnimation:EGG_Animation myPlayer:enemy];
    }else{
        [player setAnimation:EGG_Animation myPlayer:player];
        [player setAnimation:EAGLE_Animation myPlayer:enemy];
    }
    
    enemy.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/6*5);
        [self addChild:player];
    [self addChild:enemy];
    
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"BackgroundImage"];
    backgroundNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    backgroundNode.zPosition = 1;
    [self addChild:backgroundNode];

}
-(void)startFirebase{
    
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
    {
        
        fireData = snapshot.value;
        NSDictionary *tmp = fireData[@"GameRoom"][userData.gameRoomKey];
  
        if ([userData.playerType isEqualToString:PLAYER_TYPE_ATTACK]) {
            
            tmp = tmp[PLAYER_TYPE_DEFENSE];
            
        }else if([userData.playerType isEqualToString:PLAYER_TYPE_DEFENSE]){
            tmp = tmp[PLAYER_TYPE_ATTACK];
        }
        if (tmp[@"posX"] && tmp[@"posY"]) {
            enemy.position = CGPointMake([tmp[@"posX"] floatValue]*self.frame.size.width,
                                         enemy.position.y);
        }


    }];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

// Player Move
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        player.position = CGPointMake(location.x, player.position.y);
        
        [self setPlayerPostion:player.position.x :player.position.y];
    }
}

-(void)setPlayerPostion:(CGFloat)posX : (CGFloat)posY{
    
    NSString *strPosX = [NSString stringWithFormat:@"%f",posX/self.frame.size.width];
    NSString *strPosY = [NSString stringWithFormat:@"%f",posY];
    
    NSDictionary *upData = @{@"posX":strPosX,@"posY":strPosY};
    NSString *path = [@"/GameRoom/" stringByAppendingString:userData.gameRoomKey];
    path = [path stringByAppendingFormat:@"/%@",userData.playerType];
    NSDictionary *childUpdates = @{path:upData};
    [ref updateChildValues:childUpdates];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
