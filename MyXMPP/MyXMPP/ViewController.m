//
//  ViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/11/19.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "ViewController.h"
#import "XMPPManager.h"

@interface ViewController () <XMPPStreamDelegate>

@property (nonatomic, assign) IBOutlet UITextField *userField;
@property (nonatomic, assign) IBOutlet UITextField *passwordField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[XMPPManager shareInterface] addStreamDelegate:self];
    [[XMPPManager shareInterface] connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnRegisterTap:(id)sender {
    [[XMPPManager shareInterface] connect];
}

#pragma mark - XMPPStream Delegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSString *username = self.userField.text;
    NSString *password = self.passwordField.text;
    [sender setMyJID:[XMPPJID jidWithUser:username domain:kHostName resource:nil]];
    NSError *err = nil;
    BOOL res = [sender registerWithPassword:password error:&err];
    if (!res) {
        NSLog(@"%s -> %@", __FUNCTION__, [err description]);
    }
}


- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"%s", __FUNCTION__);
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    NSLog(@"%s -> %@", __FUNCTION__, [error prettyXMLString]);
}

@end
