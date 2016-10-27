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
#import "Monster.h"

@import Firebase;

struct PhysicsCatagory{
    int Enemy;
    int PlayerBullet;
    int Player;
    int ScoreWall;
};

//定義工作型別 將原本的型別取個新的名稱 （將一個匿名方法block定義）
typedef void(^FIRBTask)(void);

@implementation GameScene{
    Player *player;
    Player *enemy;
    SKSpriteNode *hpUI;
    SKSpriteNode *background;
    SKSpriteNode *callMonsterBar;
    SKSpriteNode *scoreWall;
    Monster *createMonser;
    FireBaseManager *userData;
    FIRDatabaseReference *ref;
    SKLabelNode *labelScore;
    CGSize playerHpMaxSize;
    CGSize enemyHpMaxSize;
    __block NSDictionary *fireData;
    struct PhysicsCatagory PhysicsCatagory;
    FIRBTask setUpload;
    NSInteger Socre;
}

-(void)didMoveToView:(SKView *)view {
    PhysicsCatagory.Enemy = 1;
    PhysicsCatagory.PlayerBullet = 2;
    PhysicsCatagory.Player = 3;
    PhysicsCatagory.ScoreWall = 4;

    
    userData = [FireBaseManager newFBData];
//    userData.playerType = PLAYER_TYPE_ATTACK;
//    userData.enemyType = PLAYER_TYPE_DEFENSE;
//    userData.playerType = PLAYER_TYPE_DEFENSE;
//    userData.enemyType = PLAYER_TYPE_ATTACK;
//    userData.gameRoomKey = @"adsadasdasfdf";
    [self startFirebase];
    labelScore = [SKLabelNode labelNodeWithFontNamed:@"Score"];
    labelScore.text = @"Score : 0";
    labelScore.fontSize = 50;
    labelScore.position = CGPointMake(130, 32);
    [self addChild:labelScore];
    Socre =0;
    scoreWall = (SKSpriteNode*)[self childNodeWithName:@"ScoreWall"];
    scoreWall.physicsBody.categoryBitMask = PhysicsCatagory.ScoreWall;
    scoreWall.physicsBody.contactTestBitMask = PhysicsCatagory.Enemy;
    
    self.physicsWorld.contactDelegate = self;
    //background = (SKSpriteNode*)[self childNodeWithName:@"background"];
    background = [SKSpriteNode spriteNodeWithImageNamed:@"GameBackground_loop.png"];
    background.zPosition = -5;
    background.size = CGSizeMake(self.frame.size.width, self.frame.size.height*2);
    background.position = CGPointMake(background.position.x, background.position.y);
    [self addChild:background];
    
    callMonsterBar = (SKSpriteNode*)[self childNodeWithName:@"CallMonsterBar"];

    
    
   /* Setup your scene here */
    player = [Player new];
    player = [player newPlayer:PlAYER];
    player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/6);
    player.physicsBody.dynamic = false;
    
    enemy = [Player new];
    enemy = [enemy newPlayer:ENEMY];
    if ([userData.playerType isEqualToString:PLAYER_TYPE_ATTACK]) {
        callMonsterBar.hidden = true;
    }
        [player setAnimation:EAGLE_Animation myPlayer:player];
    player.hp = 100;
    enemy.hp = 100;
    [self addChild:player];
    //[self addChild:enemy];

    
    NSTimer *playerBullets = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(playerBullets) userInfo:nil repeats:true];
    SKSpriteNode *hpNode = (SKSpriteNode*)[player childNodeWithName:PlAYER];
    playerHpMaxSize = hpNode.size;
    SKSpriteNode *hpNode2 = (SKSpriteNode*)[enemy childNodeWithName:ENEMY];
    enemyHpMaxSize = hpNode2.size;
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
            tmp = tmp[@"AddMonster"];
            
            if(tmp){
                createMonser = [Monster new];
                [createMonser createMonsterById:1];
                [self addChild:createMonser.monster];
                createMonser.monster.physicsBody.categoryBitMask = PhysicsCatagory.Enemy;
                createMonser.monster.physicsBody.contactTestBitMask = PhysicsCatagory.PlayerBullet;
                createMonser.monster.position = CGPointMake([tmp[@"posX"] floatValue]*self.frame.size.width,
                                                            [tmp[@"posY"] floatValue]*self.frame.size.height);
                createMonser.monster.name = @"monster";
                [createMonser monsterAutoMove:self.size.height];
                FIRDatabaseReference *ref2 = [[[[ref child:@"GameRoom"] child:userData.gameRoomKey] child:PLAYER_TYPE_DEFENSE] child:@"AddMonster"];
                [ref2 setValue:nil];
                createMonser = nil;

        }
            
        }else if([userData.playerType isEqualToString:PLAYER_TYPE_DEFENSE]){
            tmp = tmp[PLAYER_TYPE_ATTACK];
            if (tmp) {
                player.position = CGPointMake([tmp[@"posX"] floatValue]*self.frame.size.width,
                                             player.position.y);
                NSString *getHp = fireData[@"GameRoom"][userData.gameRoomKey][userData.enemyType][@"hp"];
                player.hp = [getHp doubleValue];
            }
        }




    }];

}

-(void) playerBullets{
    SKSpriteNode *Bullet = [SKSpriteNode spriteNodeWithImageNamed:@"BulletGalaga.png"];
    Bullet.zPosition = -0.5;
    Bullet.position = CGPointMake(player.position.x, player.position.y+5);
    Bullet.size = CGSizeMake(player.size.height/5, player.size.width/5);
    Bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:Bullet.size];
    Bullet.physicsBody.categoryBitMask = PhysicsCatagory.PlayerBullet;
    Bullet.physicsBody.contactTestBitMask = PhysicsCatagory.Enemy;
    Bullet.physicsBody.affectedByGravity = false;
    Bullet.physicsBody.dynamic = false;
    Bullet.name = @"Bullet";
    
    SKAction *action = [SKAction moveToY:self.size.height+30 duration:1];
    SKAction *actionremove = [SKAction removeFromParent];
    //SKAction *End = [SKAction performSelector:@selector(getFIBPostion) onTarget:self];
    [Bullet runAction:[SKAction sequence:@[action,actionremove]]];
    [self addChild:Bullet];
}

// 碰撞
-(void)didBeginContact:(SKPhysicsContact *)contact{
    NSLog(@"碰撞");
    SKPhysicsBody *firstBody = contact.bodyA;
    SKPhysicsBody *seconBody = contact.bodyB;
    if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy && seconBody.categoryBitMask == PhysicsCatagory.PlayerBullet)||
        (firstBody.categoryBitMask == PhysicsCatagory.PlayerBullet && seconBody.categoryBitMask ==PhysicsCatagory.Enemy)) {
        [firstBody.node removeFromParent];
        [seconBody.node removeFromParent];
        if ([userData.playerType isEqualToString:PLAYER_TYPE_ATTACK]) {
             Socre += 100;
        }
       
        
    }else if ( (firstBody.categoryBitMask == PhysicsCatagory.ScoreWall) || (seconBody.categoryBitMask == PhysicsCatagory.ScoreWall)){
        
        if ([userData.playerType isEqualToString:PLAYER_TYPE_DEFENSE]) {
            Socre += 600;
        }
        
    }
        labelScore.text = [NSString stringWithFormat:@"Score : %li",(long)Socre];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if ([userData.playerType isEqualToString:PLAYER_TYPE_DEFENSE]) {
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            SKNode *tounchNods =  [self nodeAtPoint:location];
            if ([tounchNods.name isEqualToString:@"AddMonster"]) {
                NSLog(@"碰到monster");
                createMonser = [Monster new];
                [createMonser createMonsterById:1];
                createMonser.monster.physicsBody.dynamic = false;
                [self addChild:createMonser.monster];
            }
        }
    }

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (createMonser && [userData.playerType isEqualToString:PLAYER_TYPE_DEFENSE]) {
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            FIRDatabaseReference *tmpRef = ref;
            
            NSString *strPosX = [NSString stringWithFormat:@"%f",location.x/self.frame.size.width];
            NSString *strPosY = [NSString stringWithFormat:@"%f",location.y/self.frame.size.height];
            
            NSDictionary *upData = @{@"posX":strPosX,@"posY":strPosY};
            NSString *path = [@"/GameRoom/" stringByAppendingString:userData.gameRoomKey];
            path = [path stringByAppendingFormat:@"/%@/AddMonster",PLAYER_TYPE_DEFENSE];
            
            
            NSDictionary *childUpdates = @{path:upData};
            [tmpRef updateChildValues:childUpdates];
            
            createMonser.monster.physicsBody.dynamic = true;
            createMonser.monster.physicsBody.categoryBitMask = PhysicsCatagory.Enemy;
            createMonser.monster.physicsBody.contactTestBitMask = PhysicsCatagory.PlayerBullet;
            [createMonser monsterAutoMove:self.size.height];
            
            createMonser = nil;
        }

    }
   
}


// Player Move
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
         CGPoint location = [touch locationInNode:self];
        if ([userData.playerType isEqualToString:PLAYER_TYPE_ATTACK]) {
            player.position = CGPointMake(location.x, player.position.y);
            [self setPlayerPostion:player.position.x :player.position.y];
        }
        if ([userData.playerType isEqualToString:PLAYER_TYPE_DEFENSE])
        {
            if (createMonser) {
                createMonser.monster.position = CGPointMake(location.x, location.y);

            }
        }

        
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //[self setPlayerPostion:player.position.x :player.position.y];
    [self viewUIHp];
    background.position = CGPointMake(background.position.x, background.position.y-3);
    if (background.position.y <= background.size.height/160.212) {
        background.position = CGPointMake(self.frame.size.width/2, 1759.788);
    }
    
}

-(void)setPlayerPostion:(CGFloat)posX : (CGFloat)posY{
    __block double tmpHp = enemy.hp;
    __block NSString *roomKey = userData.gameRoomKey;
    __block FIRDatabaseReference *tmpRef = ref;
    setUpload = ^{
        
        NSString *strPosX = [NSString stringWithFormat:@"%f",posX/self.frame.size.width];
        NSString *strPosY = [NSString stringWithFormat:@"%f",posY];
        
        NSString *strHp = [NSString stringWithFormat:@"%f",tmpHp];
        
        NSDictionary *upData = @{@"posX":strPosX,@"posY":strPosY,@"hp":strHp};
        NSString *path = [@"/GameRoom/" stringByAppendingString:roomKey];
        path = [path stringByAppendingFormat:@"/%@",userData.playerType];
        
        
        NSDictionary *childUpdates = @{path:upData};
        [tmpRef updateChildValues:childUpdates];
        
    };
    
    dispatch_queue_t concurrQueue = dispatch_queue_create("aConcurrentQ", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(concurrQueue, setUpload);


}


-(void)viewUIHp{
    //player.hpUI.size = CGSizeMake(Width * (player.hp/100.0), Height);
    if (player.hp>=0) {
        SKSpriteNode *playerHp = (SKSpriteNode*)[player childNodeWithName:PlAYER];
        CGFloat Width = playerHpMaxSize.width;
        CGFloat Height = playerHp.size.height;
        playerHp.size = CGSizeMake(Width * (player.hp/100.0), Height);
    }

    
}


@end
