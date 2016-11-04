//
//  FriendTableViewController.h
//  CuckooChicken
//
//  Created by Snos on 2016/11/4.
//  Copyright © 2016年 Snow. All rights reserved.
//
#import "GameScene.h"
#import "GameViewController.h"
#import <UIKit/UIKit.h>

@interface FriendTableViewController : UITableViewController
@property(strong,nonatomic) SKScene *myScene;
@property(strong,nonatomic) GameViewController *vc;

@end
