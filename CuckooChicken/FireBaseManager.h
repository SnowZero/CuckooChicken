//
//  FireBaseManager.h
//  CuckooChicken
//
//  Created by Snos on 2016/10/15.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FireBaseManager : NSObject

@property(strong,nonatomic) __block NSDictionary *userData;

+(instancetype) newFBData;


@end
