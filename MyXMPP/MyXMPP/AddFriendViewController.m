//
//  AddFriendViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/7.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "AddFriendViewController.h"
#import "XMPPManager.h"

@interface AddFriendViewController ()

@property (nonatomic, strong) IBOutlet UITextField *friendID;


@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)btnAddFriendTap {
    [[XMPPManager shareInterface] addFriendWithID:self.friendID.text];
}

@end
