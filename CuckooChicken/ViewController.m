//
//  ViewController.m
//  CuckooChicken
//
//  Created by Snos on 2016/9/12.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"类别修改" message:@"11 " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改",nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        //點了取消
    }else if(buttonIndex==1){
        //點了確定，在Log顯示使用者輸入的字串
        UITextField *textfield =  [alertView textFieldAtIndex: 0];
        NSLog(@"user input:%@",[textfield text]);

    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
