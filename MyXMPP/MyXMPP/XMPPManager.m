//
//  XMPPManager.m
//  MyXMPP
//
//  Created by halloworld on 15/11/29.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "XMPPManager.h"
#import <DDTTYLogger.h>
#import "def.h"

@interface XMPPManager () <XMPPStreamDelegate>

@property (nonatomic, strong) XMPPStream *xmppStream;

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
    }
    return self;
}

- (XMPPStream *)xmppStream {
    return _xmppStream;
}


- (void)addStreamDelegate:(id<XMPPStreamDelegate>)aDelegate {
    [self.xmppStream addDelegate:aDelegate delegateQueue:dispatch_get_main_queue()];
}

- (void)connect {
    [self.xmppStream setMyJID:[XMPPJID jidWithUser:@"unknow" domain:kHostName resource:nil]];
    NSError *err = nil;
    BOOL result = [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err];
    NSAssert(result, [err description]);
}


@end
