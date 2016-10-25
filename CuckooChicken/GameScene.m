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
    int PlayerBullet;
    int Player;
    int EnemyBullet;
};

//定義工作型別 將原本的型別取個新的名稱 （將一個匿名方法block定義）
typedef void(^FIRBTask)(void);

@implementation GameScene{
    Player *player;
    Player *enemy;
    SKSpriteNode *hpUI;
    SKSpriteNode *background;
    FireBaseManager *userData;
    FIRDatabaseReference *ref;
    CGSize playerHpMaxSize;
    CGSize enemyHpMaxSize;
    __block NSDictionary *fireData;
    struct PhysicsCatagory PhysicsCatagory;
    FIRBTask setUpload;
}

-(void)didMoveToView:(SKView *)view {
    userData = [FireBaseManager newFBData];
    [self startFirebase];
    self.physicsWorld.contactDelegate = self;
    background = (SKSpriteNode*)[self childNodeWithName:@"background"];
    background.zPosition = -1;
    background.size = CGSizeMake(self.frame.size.width, self.frame.size.height*2);
    background.position = CGPointMake(background.position.x, background.position.y);
    
    PhysicsCatagory.Enemy = 1;
    PhysicsCatagory.PlayerBullet = 2;
    PhysicsCatagory.Player = 3;
    PhysicsCatagory.EnemyBullet = 4;
    
   /* Setup your scene here */
    player = [Player new];
    player = [player newPlayer:PlAYER];
    player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/6);
    player.physicsBody.dynamic = false;
    
    enemy = [Player new];
    enemy = [enemy newPlayer:ENEMY];
    if ([userData.playerType isEqualToString:PLAYER_TYPE_ATTACK]) {
        [player setAnimation:EAGLE_Animation myPlayer:player];
        [player setAnimation:EGG_Animation myPlayer:enemy];
    }else{
        [player setAnimation:EGG_Animation myPlayer:player];
        [player setAnimation:EAGLE_Animation myPlayer:enemy];
    }
    enemy.physicsBody.affectedByGravity = false;
    enemy.physicsBody.dynamic = false;
    enemy.physicsBody.categoryBitMask = PhysicsCatagory.Enemy;
    enemy.physicsBody.contactTestBitMask = PhysicsCatagory.PlayerBullet;
    enemy.position = CGPointMake(self.frame.size.width/2, self.size.height/6*5);

    player.hp = 100;
    enemy.hp = 100;
    [self addChild:player];
    [self addChild:enemy];

    
    NSTimer *playerBullets = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(playerBullets) userInfo:nil repeats:true];
    NSTimer *enemyBullets = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(enemyBullets) userInfo:nil repeats:true];
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
            
        }else if([userData.playerType isEqualToString:PLAYER_TYPE_DEFENSE]){
            tmp = tmp[PLAYER_TYPE_ATTACK];
        }
        if (tmp) {
            enemy.position = CGPointMake([tmp[@"posX"] floatValue]*self.frame.size.width,
                                         enemy.position.y);
            NSString *getHp = fireData[@"GameRoom"][userData.gameRoomKey][userData.enemyType][@"hp"];
            player.hp = [getHp doubleValue];
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
    Bullet.physicsBody.dynamic = true;

    
    SKAction *action = [SKAction moveToY:self.size.height+30 duration:0.6];
    SKAction *actionremove = [SKAction removeFromParent];
    //SKAction *End = [SKAction performSelector:@selector(getFIBPostion) onTarget:self];
    [Bullet runAction:[SKAction sequence:@[action,actionremove]]];
    [self addChild:Bullet];
    [self setPlayerPostion:player.position.x :player.position.y];
}
-(void) enemyBullets{
    SKSpriteNode *Bullet = [SKSpriteNode spriteNodeWithImageNamed:@"BulletGalaga.png"];
    Bullet.zPosition = -0.5;
    Bullet.position = CGPointMake(enemy.position.x, enemy.position.y-1);
    Bullet.size = CGSizeMake(enemy.size.height/5, enemy.size.width/5);
    Bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:Bullet.size];
    Bullet.physicsBody.categoryBitMask = PhysicsCatagory.EnemyBullet;
    Bullet.physicsBody.contactTestBitMask = PhysicsCatagory.Player;
    Bullet.physicsBody.affectedByGravity = false;
    Bullet.physicsBody.dynamic = true;
    
    
    SKAction *action = [SKAction moveToY:-self.size.height-30 duration:0.6];
    SKAction *actionremove = [SKAction removeFromParent];
    [Bullet runAction:[SKAction sequence:@[action,actionremove]]];
    [self addChild:Bullet];
    
}
// 碰撞
-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody = contact.bodyA;
    SKPhysicsBody *seconBody = contact.bodyB;
    NSLog(@"有碰撞");
    if(((firstBody.categoryBitMask == PhysicsCatagory.Enemy)&&
        (seconBody.categoryBitMask == PhysicsCatagory.PlayerBullet))) {
           
           [self CollisionWithBullet:seconBody.node];
        NSLog(@"有碰撞2");
    }
}
-(void)CollisionWithBullet:(SKSpriteNode*) Bullet{
    [Bullet removeFromParent];
    enemy.hp--;
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


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //[self setPlayerPostion:player.position.x :player.position.y];
    [self viewUIHp];
    background.position = CGPointMake(background.position.x, background.position.y-3);
    NSLog(@"pox:%f posY:%f",background.position.x,background.position.y);
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
    SKSpriteNode *playerHp = (SKSpriteNode*)[player childNodeWithName:PlAYER];
    CGFloat Width = playerHpMaxSize.width;
    CGFloat Height = playerHp.size.height;
    playerHp.size = CGSizeMake(Width * (player.hp/100.0), Height);
    
    SKSpriteNode *enemyHp = (SKSpriteNode*)[enemy childNodeWithName:ENEMY];
    CGFloat enemyWidth = enemyHpMaxSize.width;
    CGFloat enemyHeight = enemyHp.size.height;
    enemyHp.size = CGSizeMake(enemyWidth * (enemy.hp/100.0), enemyHeight);
    
}


@end
