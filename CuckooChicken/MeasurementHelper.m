//
//  MeasurementHelper.m
//  
//
//  Created by LynnLin on 2016/10/10.
//
//

#import "MeasurementHelper.h"

@import Firebase;

@implementation MeasurementHelper

+ (void)sendLoginEvent {
    [FIRAnalytics logEventWithName:kFIREventLogin parameters:nil];
}

+ (void)sendLogoutEvent {
    [FIRAnalytics logEventWithName:@"logout" parameters:nil];
}

+ (void)sendMessageEvent{
    [FIRAnalytics logEventWithName:@"message" parameters:nil];
}

@end
