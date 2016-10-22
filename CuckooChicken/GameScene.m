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

struct PhysicsCatagory{
    int Enemy;
    int Bullet;
    int Player;
};

@implementation GameScene{
    Player *player;
    Player *enemy;
    FireBaseManager *userData;
    FIRDatabaseReference *ref;
    __block NSDictionary *fireData;
    struct PhysicsCatagory PhysicsCatagory;
}

-(void)didMoveToView:(SKView *)view {
    userData = [FireBaseManager newFBData];
    [self startFirebase];
    self.physicsWorld.contactDelegate = self;
    
    PhysicsCatagory.Enemy = 1;
    PhysicsCatagory.Bullet = 2;
    PhysicsCatagory.Player = 3;
    
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
    enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemy.size];
    enemy.physicsBody.affectedByGravity = false;
    enemy.physicsBody.dynamic = true;
    enemy.physicsBody.categoryBitMask = PhysicsCatagory.Enemy;
    enemy.physicsBody.contactTestBitMask = PhysicsCatagory.Bullet;
    enemy.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/6*5);
        [self addChild:player];
    [self addChild:enemy];
    
//    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"BackgroundImage"];
//    backgroundNode.position = CGPointMake(self.size.width/2, self.size.height/2);
//    backgroundNode.zPosition = 1;
//    [self addChild:backgroundNode];
    NSTimer *timerBullets = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(spawnBullets) userInfo:nil repeats:true];



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

-(void) spawnBullets{
    SKSpriteNode *Bullet = [SKSpriteNode spriteNodeWithImageNamed:@"BulletGalaga.png"];
    Bullet.zPosition = -5;
    Bullet.position = CGPointMake(player.position.x, player.position.y);
    Bullet.size = CGSizeMake(player.size.height/5, player.size.width/5);
    Bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:Bullet.size];
    Bullet.physicsBody.categoryBitMask = PhysicsCatagory.Bullet;
    Bullet.physicsBody.contactTestBitMask = PhysicsCatagory.Enemy;
    Bullet.physicsBody.affectedByGravity = false;
    Bullet.physicsBody.dynamic = true;
    
    
    SKAction *action = [SKAction moveToY:self.size.height+30 duration:0.6];
    SKAction *actionremove = [SKAction removeFromParent];
    //SKAction *End = [SKAction performSelector:@selector(getFIBPostion) onTarget:self];
    [Bullet runAction:[SKAction sequence:@[action,actionremove]]];
    [self addChild:Bullet];

}

// 碰撞
-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody = contact.bodyA;
    SKPhysicsBody *seconBody = contact.bodyB;
    NSLog(@"有碰撞");
    if (firstBody.categoryBitMask == 1 && seconBody.categoryBitMask ==2||
        firstBody.categoryBitMask == 2 && seconBody.categoryBitMask ==1) {
        NSLog(@"有碰撞2");
    }
}
-(void)CollisionWithBullet:(SKSpriteNode*)Enemy :(SKSpriteNode*) Bullet{
    [Enemy removeFromParent];
    [Bullet removeFromParent];
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
