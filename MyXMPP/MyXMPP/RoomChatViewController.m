//
//  RoomChatViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/23.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "RoomChatViewController.h"

@interface RoomChatViewController () <XMPPRoomDelegate>

@property (nonatomic, weak) IBOutlet UITextView *chatTextView;

@property (nonatomic, weak) IBOutlet UITextField *sendText;

@end

@implementation RoomChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStyleDone target:self action:@selector(invateFriend)];
    [self.room addDelegate:self delegateQueue:dispatch_get_main_queue()];
}


- (void)invateFriend {
    XMPPJID *hq1234 = [XMPPJID jidWithUser:@"hq1234" domain:kHostName resource:nil];
    [self.room inviteUser:hq1234 withMessage:@"大爷，来玩嘛！！！"];
}


- (IBAction)btnSendTap:(id)sender {
    [self.room sendMessageWithBody:self.sendText.text];
}


- (void)alertMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - RoomDelegate

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence {
    [self alertMessage:[NSString stringWithFormat:@"%@ 加入了房间", [occupantJID full]]];
}


- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence {
    [self alertMessage:[NSString stringWithFormat:@"%@ 离开了房间", [occupantJID full]]];
}


- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID {
    [self showChatText:[message body] from:[occupantJID resource]];
}

- (void)showChatText:(NSString *)chatString from:(NSString *)aUser {
    NSString *chatContent = self.chatTextView.text;
    chatContent = [chatContent stringByAppendingFormat:@"%@ : %@\n", aUser, chatString];
    self.chatTextView.text = chatContent;
}

@end
