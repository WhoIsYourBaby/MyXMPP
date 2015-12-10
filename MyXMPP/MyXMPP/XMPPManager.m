//
//  XMPPManager.m
//  MyXMPP
//
//  Created by halloworld on 15/11/29.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "XMPPManager.h"
#import <XMPPRosterCoreDataStorage.h>
#import <DDTTYLogger.h>
#import "def.h"

@interface XMPPManager () <XMPPStreamDelegate, XMPPRosterDelegate>

@property (nonatomic, strong) XMPPStream *xmppStream;

@property (nonatomic, strong) XMPPRoster *xmppRoster;

@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;

@end

@implementation XMPPManager

+ (instancetype)shareInterface {
    static XMPPManager *managerInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerInterface = [[XMPPManager alloc] init];
    });
    return managerInterface;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        _xmppStream = [[XMPPStream alloc] init];
        [_xmppStream setHostName:kHostName];
        [_xmppStream setHostPort:5222];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //初始化好友管理功能
        _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
        [_xmppRoster activate:_xmppStream];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (XMPPStream *)xmppStream {
    return _xmppStream;
}


- (void)addStreamDelegate:(id<XMPPStreamDelegate>)aDelegate {
    [self.xmppStream addDelegate:aDelegate delegateQueue:dispatch_get_main_queue()];
}

- (void)removeStreamDelegate:(id<XMPPStreamDelegate>)aDelegate {
    [self.xmppStream removeDelegate:aDelegate];
}

- (void)connect {
    [self.xmppStream setMyJID:[XMPPJID jidWithUser:@"unknow" domain:kHostName resource:nil]];
    NSError *err = nil;
    BOOL result = [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err];
    NSAssert(result, [err description]);
}


- (void)addFriendWithID:(NSString *)friendID {
    [_xmppRoster subscribePresenceToUser:[XMPPJID jidWithUser:friendID domain:kHostName resource:nil]];
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    XMPPJID *jidFrom = [presence from];
    [sender acceptPresenceSubscriptionRequestFrom:jidFrom andAddToRoster:YES];
}


@end
