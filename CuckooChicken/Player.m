//
//  Player.m
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "Player.h"
#import "FireBaseManager.h"


@implementation Player{
    Player *player;
    
}

- (Player*)newPlayer:(NSString*)playerType{
    
    player = [Player spriteNodeWithImageNamed:@"eagle_back1"];
    
    player.name = @"player";
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.affectedByGravity = NO;
    player.physicsBody.dynamic = false;
    player.physicsBody.categoryBitMask = 3;
    player.physicsBody.contactTestBitMask =4;
    
    _hpUI = [SKSpriteNode spriteNodeWithImageNamed:@"UI_blood.png"];
    _hpUI.size = CGSizeMake(player.size.width/1.4, player.size.height/12);
    
    _hpUI.zPosition = 1;
    
    _hpUI.name = PlAYER;
    _hpUI.position = CGPointMake(player.position.x, player.position.y-player.size.height/3);

    
    NSLog(@"W:%f  H:%f",_hpUI.size.width,_hpUI.size.height);
    [player addChild:_hpUI];
    return player;

}

- (void)setAnimation:(NSString *)animationKey myPlayer:(SKSpriteNode *)myPlayer{    
    SKTexture *runTexture1;
    SKTexture *runTexture2;
    if ([animationKey isEqualToString:EAGLE_Animation]) {
            runTexture1 = [SKTexture textureWithImageNamed:@"eagle_back1.png"];
            runTexture2 = [SKTexture textureWithImageNamed:@"eagle_back2.png"];

    }else if([animationKey isEqualToString:EGG_Animation]){
        runTexture1 = [SKTexture textureWithImageNamed:@"egg-1.png"];
        runTexture2 = [SKTexture textureWithImageNamed:@"egg-2.png"];
        
    }
    
    NSArray *TextureArray = @[runTexture1 ,runTexture2];
    SKAction *runAnimation = [SKAction animateWithTextures:TextureArray timePerFrame:0.5];
    [myPlayer runAction:[SKAction repeatActionForever:runAnimation]];

}

@end
