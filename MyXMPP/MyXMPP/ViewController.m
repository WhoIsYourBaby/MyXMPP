//
//  ViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/11/19.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "ViewController.h"
#import "XMPPManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[XMPPManager shareInterface] connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
