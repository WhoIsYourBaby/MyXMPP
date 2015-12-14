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
@property (nonatomic, weak) IBOutlet UITextField *sendText;
@property (nonatomic, weak) IBOutlet UITextView *chatText;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setChatFriendJid:(XMPPJID *)aJid {
    self.friendJid = aJid;
}

- (IBAction)btnSendTap:(id)sender {
}

@end
