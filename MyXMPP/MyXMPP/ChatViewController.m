//
//  ChatViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/14.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@property (nonatomic, strong) XMPPJID *friendJid;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setChatFriendJid:(XMPPJID *)aJid {
    self.friendJid = aJid;
}

@end
