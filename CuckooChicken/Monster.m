//
//  Monster.m
//  CuckooChicken
//
//  Created by Snos on 2016/10/26.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "Monster.h"
struct PhysicsCatagory{
    int Enemy;
    int PlayerBullet;
    int Player;
    int EnemyBullet;
};


@implementation Monster{
    struct PhysicsCatagory PhysicsCatagory;
}

-(void)createMonsterById:(int)monsterId{
    _hp =5;
    
    switch (monsterId) {
        case 1:
            _monster = [SKSpriteNode spriteNodeWithImageNamed:@"egg-1"];
            break;
            
        default:
            break;
    }
    _monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_monster.size];
    _monster.physicsBody.affectedByGravity = false;
    _monster.physicsBody.dynamic = true;
    _monster.physicsBody.categoryBitMask = PhysicsCatagory.Enemy;
    _monster.physicsBody.contactTestBitMask = PhysicsCatagory.PlayerBullet;
    _monster.name = @"monster";
}
-(void)hitMonster{
    _monster.physicsBody.collisionBitMask--;
    NSLog(@"hp--:%i",_monster.physicsBody.collisionBitMask);
    if (_monster.physicsBody.collisionBitMask ==0) {
        NSLog(@"死掉了");
        SKAction *actionremove = [SKAction removeFromParent];
        [_monster runAction:[SKAction sequence:@[actionremove]]];
    }
}

-(void)monsterAutoMove:(double)selfFrameSize{
    SKAction *action = [SKAction moveToY:-selfFrameSize-30 duration:10];
    SKAction *actionremove = [SKAction removeFromParent];
    [_monster runAction:[SKAction sequence:@[action,actionremove]]];
}




@end
