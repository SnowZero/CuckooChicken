//
//  AppState.h
//  HelloIGA
//
//  Created by LynnLin on 2016/10/10.
//  Copyright © 2016年 LynnHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppState : NSObject

+ (AppState *)sharedInstance;

@property (nonatomic) BOOL signedIn;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSURL *photoUrl;


@end
