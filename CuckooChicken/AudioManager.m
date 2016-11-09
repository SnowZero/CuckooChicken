//
//  AudioManager.m
//  CuckooChicken
//
//  Created by Snos on 2016/11/9.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioManager
static AudioManager *audioManager = nil;

+(instancetype)stariAudio{
    if (audioManager == nil) {
        audioManager = [AudioManager new];
    }
    return audioManager;
}

-(void)MainCityPlay{

    NSURL *soundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MainCity" ofType:@"mp3"]];
    _Audio = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_Audio play];
}

-(void)FirePlay{
    NSURL *soundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Fire" ofType:@"mp3"]];
    _Audio = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_Audio play];
}


@end
