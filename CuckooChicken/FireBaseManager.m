//
//  FireBaseManager.m
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "FireBaseManager.h"
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
    finish = false;
    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    
    _ref = [[FIRDatabase database] referenceFromURL:strUrl];
    
    [_ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        _userData = snapshot.value;
        if (finish == false) {
            finish = true;
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
    [[[[[_ref child:@"user"] child:_userUID] child:@"friend"] child:firendID] setValue:@"1"];
    
}
-(void)setUserName:(NSString *)userName{
    [[[[_ref child:@"user"] child:_userUID] child:@"name"] setValue:userName];
}
-(NSString*)getUserName:(NSString *)userID{
   return _userData[@"user"][userID][@"name"];
}

@end
