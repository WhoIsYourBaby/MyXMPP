//
//  AddFriendViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/7.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "AddFriendViewController.h"

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(btnAddFriendTap)];
}


- (void)btnAddFriendTap {
}

@end
