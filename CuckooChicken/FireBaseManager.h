//
//  FireBaseManager.h
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLAYER_TYPE_ATTACK @"PlayerAttack"
#define PLAYER_TYPE_DEFENSE @"PlayerDefense"
@interface FireBaseManager : NSObject

@property(strong,nonatomic) __block NSDictionary *userData;
@property(strong,nonatomic) NSString *playerType;
@property(strong,nonatomic) NSString *enemyType;
@property(strong,nonatomic) NSString *gameRoomKey;
@property(nonatomic,assign)  NSInteger score;

+(instancetype) newFBData;

-(void) setData:(NSDictionary*) data;

-(NSDictionary*) getData;
@end
