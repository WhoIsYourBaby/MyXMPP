//
//  ChatViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/14.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "ChatViewController.h"
#import <RTLabel.h>

@interface ChatViewController () <XMPPStreamDelegate>

@property (nonatomic, strong) XMPPJID *friendJid;
@property (nonatomic, weak) IBOutlet UITextField *sendText;
@property (nonatomic, weak) IBOutlet UIScrollView *chatScrollView;

@property CGFloat maxHeight;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[XMPPManager shareInterface] addStreamDelegate:self];
    self.maxHeight = 0.f;
}

- (void)setChatFriendJid:(XMPPJID *)aJid {
    self.friendJid = aJid;
}

- (IBAction)btnSendTap:(id)sender {
    NSString *chatContent = self.sendText.text;
    NSString *user = [[[[XMPPManager shareInterface] xmppStream] myJID] user];
    [self showChatText:chatContent from:user];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [self sendContent:chatContent];
    
    self.sendText.text = @"";
}

- (void)sendContent:(NSString *)text {
    NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:text];
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    [msg addChild:body];
    [[[XMPPManager shareInterface] xmppStream] sendElement:msg];
}


- (void)showChatText:(NSString *)chatString from:(NSString *)aUser {
    NSString *chatContent = [NSString stringWithFormat:@"%@ : %@\n", aUser, chatString];
    CGFloat sWidth = [UIScreen mainScreen].bounds.size.width;
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(0, self.maxHeight, sWidth, 1)];
    label.text = chatContent;
    CGSize opSize = label.optimumSize;
    CGRect labelFrame = label.frame;
    labelFrame.size.height = opSize.height;
    label.frame = labelFrame;
    [self.chatScrollView addSubview:label];
    self.chatScrollView.contentSize = CGSizeMake(sWidth, self.maxHeight);
    self.maxHeight += opSize.height;
}

#pragma mark - 收到消息

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSString *user = [[message from] user];
    NSString *chatContent = [message body];
    [self showChatText:chatContent from:user];
}

@end
