//
//  ViewController.m
//  TableView_MVP
//
//  Created by 腾 on 2017/1/14.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)testAction:(id)sender {
    [self.navigationController pushViewController:[TestViewController new] animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
