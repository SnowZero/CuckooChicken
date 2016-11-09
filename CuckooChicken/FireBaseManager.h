//
//  FireBaseManager.h
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

#define PLAYER_TYPE_ATTACK @"PlayerAttack"
#define PLAYER_TYPE_DEFENSE @"PlayerDefense"

@import Firebase;

@interface FireBaseManager : NSObject

@property(strong,nonatomic) __block NSDictionary *userData;
@property(strong,nonatomic) NSString *playerType;
@property(strong,nonatomic) NSString *enemyType;
@property(strong,nonatomic) NSString *gameRoomKey;
@property(nonatomic,assign) NSInteger score;
@property(strong,nonatomic) NSString *userUID;
@property(strong,nonatomic) NSString *enemyUID;
@property(strong,nonatomic) FIRDatabaseReference *ref;
@property(strong,nonatomic) UIViewController *vc;
@property(assign,nonatomic) bool isTabelView;

+(instancetype) newFBData;

-(void) setData:(NSDictionary*) data;

-(bool)askUserDataFinish;
-(NSDictionary*) getData;
- (void)startGetFirebase;
- (void)startGetFirebase:(UIViewController*)vc:(SKScene*)myScene:(bool)isTabelView;
-(void)setUserFriend:(NSString*)firendID;
-(void)setUserName:(NSString*)userName;
-(NSString*)getUserName:(NSString*)userID;
-(bool)checkIsUserFriend:(NSString*)enemyUID;

@end
