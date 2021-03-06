//
//  GameCenterManager.m
//  CuckooChicken
//
//  Created by Snos on 2016/10/29.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "GameCenterManager.h"
#import "FireBaseManager.h"

@implementation GameCenterManager{

}


-(void)authPlayer:(GameViewController*)thisVC{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [thisVC presentViewController:viewController animated:true completion:nil];
        }else{
            NSLog(@"%d",[[GKLocalPlayer localPlayer] isAuthenticated]);
        }
    };
}

-(void)saveHighscore:(int)number{
    if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
        GKScore* scoreRepoter =[[GKScore alloc] initWithLeaderboardIdentifier:@"Score"];
        scoreRepoter.value = number;
        NSArray *scoreArray = @[scoreRepoter];
        [GKScore reportScores:scoreArray withCompletionHandler:nil];
    }
}

-(void)showLeaderBoard:(GameViewController*)thisVC{
    GKGameCenterViewController *gvc = [GKGameCenterViewController new];
    gvc.gameCenterDelegate = self;
    [thisVC presentViewController:gvc animated:true completion:nil];
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:true completion:nil];
}

@end
