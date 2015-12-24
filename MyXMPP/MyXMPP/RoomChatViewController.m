//
//  RoomChatViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/23.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "RoomChatViewController.h"

@implementation RoomChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStyleDone target:self action:@selector(invateFriend)];
}


- (void)invateFriend {
    XMPPJID *hq1234 = [XMPPJID jidWithUser:@"hq1234" domain:kHostName resource:nil];
    [self.room inviteUser:hq1234 withMessage:@"大爷，来玩嘛！！！"];
}

@end
