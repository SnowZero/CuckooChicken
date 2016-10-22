//
//  Player.m
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "Player.h"



@implementation Player{
    Player *player;

}

- (Player*)newPlayer:(float)mySize{
    
    player = [Player spriteNodeWithImageNamed:@"eagle_back1"];
    
    player.name = @"player";
    player.size = CGSizeMake(player.size.height * mySize, player.size.width * mySize);
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.affectedByGravity = NO;
    player.physicsBody.dynamic = false;
    player.physicsBody.categoryBitMask = 3;
    player.physicsBody.contactTestBitMask =1;
    

    return player;

}

- (void)setAnimation:(NSString *)animationKey myPlayer:(SKSpriteNode *)myPlayer{
    FireBaseManager *userData = [FireBaseManager newFBData];
    
    SKTexture *runTexture1;
    SKTexture *runTexture2;
    if ([animationKey isEqualToString:EAGLE_Animation]) {
        if ([userData.playerType isEqualToString:PLAYER_TYPE_ATTACK]) {
            runTexture1 = [SKTexture textureWithImageNamed:@"eagle_back1.png"];
            runTexture2 = [SKTexture textureWithImageNamed:@"eagle_back2.png"];
        }else{
            runTexture1 = [SKTexture textureWithImageNamed:@"eagle-1.png"];
            runTexture2 = [SKTexture textureWithImageNamed:@"eagle-2.png"];
        }


    }else if([animationKey isEqualToString:EGG_Animation]){
        runTexture1 = [SKTexture textureWithImageNamed:@"egg-1.png"];
        runTexture2 = [SKTexture textureWithImageNamed:@"egg-2.png"];
        
    }
    
    NSArray *TextureArray = @[runTexture1 ,runTexture2];
    SKAction *runAnimation = [SKAction animateWithTextures:TextureArray timePerFrame:0.5];
    [myPlayer runAction:[SKAction repeatActionForever:runAnimation]];

}
@end
