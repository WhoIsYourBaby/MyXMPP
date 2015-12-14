//
//  AddFriendViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/7.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "AddFriendViewController.h"
#import "XMPPManager.h"

@interface AddFriendViewController () <XMPPRosterDelegate>

@property (nonatomic, strong) IBOutlet UITextField *friendID;


@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)btnAddFriendTap {
    [[XMPPManager shareInterface] addStreamDelegate:self];
    [[XMPPManager shareInterface] addFriendWithID:self.friendID.text];
}

/**
 * Sent when the roster receives a roster item.
 *
 * Example:
 *
 * <item jid='romeo@example.net' name='Romeo' subscription='both'>
 *   <group>Friends</group>
 * </item>
 **/
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item {
    [[XMPPManager shareInterface] removeStreamDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
