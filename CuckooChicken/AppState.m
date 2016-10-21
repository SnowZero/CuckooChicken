//
//  AppState.m
//  HelloIGA
//
//  Created by LynnLin on 2016/10/10.
//  Copyright © 2016年 LynnHouse. All rights reserved.
//

#import "AppState.h"

@implementation AppState

+ (AppState *)sharedInstance {
    static AppState *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}


@end
