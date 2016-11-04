//
//  GameViewController.m
//  CuckooChicken
//
//  Created by Snos on 2016/9/12.
//  Copyright (c) 2016年 Snow. All rights reserved.
//

#import "GameViewController.h"
#import "FriendTableViewController.h"
#import "GameScene.h"
#import "MainCity.h"

@import Firebase;

@implementation GameViewController
{
    MainCity *scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
//    GameScene *scene = [GameScene nodeWithFileNamed:@"MainCity"];
    scene = [MainCity nodeWithFileNamed:@"MainCity"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    scene.vc = self;
    [skView presentScene:scene];
}

-(void)showAlert:(id)object{
    NSLog(@"dsdsds");
}

-(void)showMyFriendTabelView{
    FriendTableViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendTable"];
    // 跳到下一頁
    mvc.vc = self;
    mvc.myScene = scene;
    [self presentViewController:mvc animated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
