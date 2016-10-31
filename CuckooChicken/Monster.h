//
//  Monster.h
//  CuckooChicken
//
//  Created by Snos on 2016/10/26.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Monster : SKSpriteNode
@property(nonatomic,assign) double hp;
@property(strong,nonnull) SKSpriteNode *monster;
@property(nonatomic,assign) int monsterId;

-(void)createMonsterById:(int)monsterId;
-(void)hitMonster;
-(void)monsterAutoMove:(double)selfFrameSize;
-(void)setAnimation;
@end
