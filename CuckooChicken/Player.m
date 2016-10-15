//
//  Player.m
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "Player.h"



@implementation Player{


}

+ (Player *)newPlayer:(float)mySize{
    
    Player *player = [Player spriteNodeWithImageNamed:@"eagle_back1"];
    
    player.name = @"player";
    player.size = CGSizeMake(player.size.height * mySize, player.size.width * mySize);
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.affectedByGravity = NO;
    player.physicsBody.dynamic = false;
    player.physicsBody.categoryBitMask = 3;
    player.physicsBody.contactTestBitMask =1;
    
    SKTexture *runTexture1 = [SKTexture textureWithImageNamed:@"eagle_back1.png"];
    SKTexture *runTexture2 = [SKTexture textureWithImageNamed:@"eagle_back2.png"];
    NSArray *TextureArray = @[runTexture1 ,runTexture2];
    SKAction *runAnimation = [SKAction animateWithTextures:TextureArray timePerFrame:0.5];
    [player runAction:[SKAction repeatActionForever:runAnimation]];

    return player;
}
@end
