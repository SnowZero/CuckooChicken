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
    
}

-(void)setupRemoteConfig{

    NSString *strUrl = [NSString stringWithFormat:@"https://cuckoo-chicken.firebaseio.com/"];
    ref = [[FIRDatabase database] referenceFromURL:strUrl];
    //[ref observeSingleEventOfType:<#(FIRDataEventType)#> withBlock:<#^(FIRDataSnapshot * _Nonnull snapshot)block#>]
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *post = snapshot.value;
        _viewLabel.text = post[@"condition"];
        
  
        
    }];
    
    
}


- (IBAction)setValueBtn:(id)sender {
    
    FIRDatabaseReference *test = [ref child:@"user"];
    test  = [test childByAutoId];
    NSDictionary *data = @{@"name":@"AA",@"password":@"123"};
    [test setValue:data];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
