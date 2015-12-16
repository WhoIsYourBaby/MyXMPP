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
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)btnLoginTap:(id)sender {
    [[XMPPManager shareInterface] addStreamDelegate:self];
    [[XMPPManager shareInterface] connect];
}

- (void)dealloc {
    [[XMPPManager shareInterface] removeStreamDelegate:self];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XMPPManager shareInterface] removeStreamDelegate:self];
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
    [sender sendElement:[XMPPPresence presence]];
    self.navigationController.navigationBarHidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    NSLog(@"%s -> %@", __FUNCTION__, [error prettyXMLString]);
}

@end
