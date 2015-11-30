//
//  LoginViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/11/30.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPManager.h"

@interface LoginViewController () <XMPPStreamDelegate>

@property (nonatomic, assign) IBOutlet UITextField *userField;
@property (nonatomic, assign) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btnLoginTap:(id)sender {
    [[XMPPManager shareInterface] addStreamDelegate:self];
    [[XMPPManager shareInterface] connect];
}


#pragma mark - XMPPStream Delegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSString *username = self.userField.text;
    NSString *password = self.passwordField.text;
    [sender setMyJID:[XMPPJID jidWithUser:username domain:kHostName resource:nil]];
    NSError *err = nil;
    BOOL res = [sender authenticateWithPassword:password error:&err];
    if (!res) {
        NSLog(@"%s -> %@", __FUNCTION__, [err description]);
    }
}


- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"%s", __FUNCTION__);
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    NSLog(@"%s -> %@", __FUNCTION__, [error prettyXMLString]);
}

@end
