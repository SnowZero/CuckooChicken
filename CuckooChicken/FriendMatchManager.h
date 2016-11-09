//
//  FriendMatchManager.h
//  CuckooChicken
//
//  Created by Snos on 2016/11/7.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface FriendMatchManager : NSObject

-(void)matchButton:(UIViewController*)myVc:(SKScene*)myScene:(NSString*)myFriendUID;
-(void)joinToRoomWithClient:(NSString*)thisRoom:(UIViewController*)myVc:(SKScene*)myScene:(bool)isTabelView;

@end
