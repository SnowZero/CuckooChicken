//
//  AudioManager.h
//  CuckooChicken
//
//  Created by Snos on 2016/11/9.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AudioManager : NSObject
@property (strong,nonatomic) AVAudioPlayer *Audio;

+(instancetype)stariAudio;
-(void)MainCityPlay;
-(void)FirePlay;
@end
