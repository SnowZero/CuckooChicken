//
//  ViewController.m
//  CuckooChicken
//
//  Created by Snos on 2016/9/12.
//  Copyright © 2016年 Snow. All rights reserved.
//

#import "ViewController.h"
@import Firebase;

@interface ViewController (){
    FIRDatabaseReference *ref;
}

@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupRemoteConfig];
    
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

//讀取Firebase資料
-(void)setupRemoteConfig{

    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    //只讀取一次  observeSingleEventOfType
    //數值改變讀取
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *post = snapshot.value;
        _viewLabel.text = post[@"condition"];
        
  
        
    }];
    
    
}

// setFirebase
- (IBAction)setValueBtn:(id)sender {
    
    // [(路徑) child: @""] 去取得下一層欄位 如果沒有這個欄位則新增
    
    FIRDatabaseReference *test = [ref child:@"user"];
    // childByAutoId 自動生成不重複的亂數ID 
    test  = [test childByAutoId];
    NSDictionary *data = @{@"name":@"AA",@"password":@"123"};
    [test setValue:data];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
