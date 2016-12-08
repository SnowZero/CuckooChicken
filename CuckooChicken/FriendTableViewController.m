//
//  FriendTableViewController.m
//  CuckooChicken
//
//  Created by Snos on 2016/11/4.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "FriendTableViewController.h"
#import "FireBaseManager.h"
#import "FriendMatchManager.h"

@interface FriendTableViewController ()
{
    FireBaseManager *userDataManager;
    NSDictionary *friendData;
    NSDictionary *otherUserData;
    FriendMatchManager *matchManager;
    NSArray *friendArray;
}

@end

@implementation FriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    userDataManager = [FireBaseManager newFBData];
    userDataManager.vc = self;
    userDataManager.isTabelView = true;
    friendData = userDataManager.userData[@"user"][userDataManager.userUID][@"friend"];
    otherUserData = userDataManager.userData[@"user"];
    NSLog(@"dataName: %@",userDataManager.userData[@"name"]);
    //移除Separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"Group2.png"]];
    matchManager = [FriendMatchManager new];
    friendArray = [friendData allKeys];
    
    self.tableView.contentInset = UIEdgeInsetsMake(22,0,0,0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return friendData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [userDataManager getUserName:friendArray[indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:@"egg-1.png"];
    

    //cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"配對.png"]];
    //設定文字背景為透明
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    //設定背景
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FriendCellRow.png"]]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"點擊");
     [matchManager matchButton:self :_myScene:friendArray[indexPath.row]];
}


- (IBAction)backMainBtn:(id)sender {
    userDataManager.isTabelView = false;
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
