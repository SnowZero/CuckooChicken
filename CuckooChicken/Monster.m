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
    _monsterId = 1;
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
    if (_monsterId == 2) {
        action = [SKAction moveToY:-selfFrameSize-30 duration:10/2];
    }
    SKAction *actionremove = [SKAction removeFromParent];
    [_monster runAction:[SKAction sequence:@[action,actionremove]]];
}

- (void)setAnimation{
    SKTexture *runTexture1;
    SKTexture *runTexture2;
    NSString *imageName = @"";
    switch (_monsterId) {
        case 1:
            imageName = @"shield";
            break;
        case 2:
                imageName = @"pirate";
            break;
        case 3:
            imageName = @"Magician";
            break;
        case 4:
            imageName = @"Priest";
            break;
        default:
            break;
    }
    NSString *imageName2 = [NSString stringWithFormat:@"%@%i.png",imageName,1];
    runTexture1 = [SKTexture textureWithImageNamed:imageName2];
    imageName = [NSString stringWithFormat:@"%@%i.png",imageName,2];
    runTexture2 = [SKTexture textureWithImageNamed:imageName];
    NSArray *TextureArray = @[runTexture1 ,runTexture2];
    SKAction *runAnimation = [SKAction animateWithTextures:TextureArray timePerFrame:0.5];
    [_monster runAction:[SKAction repeatActionForever:runAnimation]];
}



@end
