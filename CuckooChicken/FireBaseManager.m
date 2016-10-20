//
//  FireBaseManager.m
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "FireBaseManager.h"
@import Firebase;

@implementation FireBaseManager

static FireBaseManager *firebase = nil;

+(instancetype)newFBData{
    if (firebase == nil) {
        firebase = [FireBaseManager new];
    }
    return firebase;
}

-(void) setData:(NSDictionary*) data
{
    firebase.userData = data;
}

-(NSDictionary *)getData {
    return firebase.userData;
}

@end
