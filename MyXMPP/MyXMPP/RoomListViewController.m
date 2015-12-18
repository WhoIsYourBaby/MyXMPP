//
//  RoomListViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/16.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "RoomListViewController.h"
#import "XMPPManager.h"

@implementation RoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)btnCreateRoomTap:(id)sender {
    [[XMPPManager shareInterface] createRoom];
}

@end
