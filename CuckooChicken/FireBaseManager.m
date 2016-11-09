//
//  FireBaseManager.m
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "FireBaseManager.h"
#import "FriendMatchManager.h"
@import Firebase;

@implementation FireBaseManager{
    NSTimer *timer;
    bool *finish;
}

static FireBaseManager *firebase = nil;

+(instancetype)newFBData{
    if (firebase == nil) {
        firebase = [FireBaseManager new];
    }
    return firebase;
}

- (void)startGetFirebase{
    
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    
    _ref = [[FIRDatabase database] referenceFromURL:strUrl];
    
    [_ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        _userData = snapshot.value;
        if (finish == false) {
            finish = true;
        }

    }];

}
- (void)startGetFirebase:(UIViewController*)vc:(SKScene*)myScene:(bool)isTabelView{
    
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    
    _ref = [[FIRDatabase database] referenceFromURL:strUrl];
    
    [_ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        _userData = snapshot.value;
        if (finish == false) {
            finish = true;
        }
        NSDictionary *tmp = _userData[@"user"][_userUID][@"Invitation"];
        if (tmp.count>0) {
            NSArray *tmpArray = tmp.allKeys;
            for (NSString *key in tmp) {
                NSDictionary *value = [tmp objectForKey:key];
                NSString *test = value[@"staySum"];
                if ([test isEqualToString:@"1"]) {
                    FriendMatchManager *match = [FriendMatchManager new];
                    [match joinToRoomWithClient:key:_vc:myScene:_isTabelView];
                    if (_isTabelView) {
                        _isTabelView = false;
                    }
                }
            }
        }
    }];
    
}
-(bool)askUserDataFinish{
    return finish;
}


-(void) setData:(NSDictionary*) data
{
    firebase.userData = data;
}

-(NSDictionary *)getData {
    return firebase.userData;
}
-(void)setUserFriend:(NSString *)firendID{
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    FIRDatabaseReference *ref2 = [[FIRDatabase database] referenceFromURL:strUrl];
    ref2 = [ref2 child:@"user"];
    ref2 = [ref2 child:_userUID];
    ref2 = [ref2 child:@"friend"];
    ref2 = [ref2 child:firendID];
    [ref2 setValue:@"1"];    
}
-(void)setUserName:(NSString *)userName{
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    FIRDatabaseReference *ref2 = [[FIRDatabase database] referenceFromURL:strUrl];
    ref2 = [ref2 child:@"user"];
    ref2 = [ref2 child:_userUID];
    ref2 = [ref2 child:@"name"];
    [ref2 setValue:userName];
}
-(NSString*)getUserName:(NSString *)userID{
   return _userData[@"user"][userID][@"name"];
}
-(bool)checkIsUserFriend:(NSString *)enemyUID{
    NSDictionary *tmp = _userData[@"user"][_userUID][@"friend"];
    for (NSString *key in tmp) {
        if ([key isEqualToString:enemyUID]) {
            return true;
        }
        
    }
    return false;
}


@end
