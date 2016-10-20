//
//  FireBaseDataController.h
//  CuckooChicken
//
//  Created by 魏凡皓 on 2016/10/12.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Firebase;

@interface FireBaseDataController : NSObject
{
    FIRDatabaseReference *ref;
}

@property (nonatomic,strong) NSMutableArray * userDataMail ;
@property (nonatomic,strong) NSMutableArray * userDataPassword ;

- (void) setupRemoteConfig;

@end
