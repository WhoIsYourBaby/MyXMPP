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

@interface XMPPManager () <XMPPStreamDelegate, XMPPRosterDelegate, XMPPMUCDelegate, XMPPRoomDelegate>

@property (nonatomic, strong) XMPPStream *xmppStream;

@property (nonatomic, strong) XMPPRoster *xmppRoster;

@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;

@property (nonatomic, strong) XMPPMUC *roomMUC;

@property (nonatomic, strong) NSMutableArray *roomsJoined;

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

- (instancetype)init {
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
        
        //初始化聊天室
        _roomMUC = [[XMPPMUC alloc] init];
        [_roomMUC addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_roomMUC activate:_xmppStream];
        
    }
    return self;
}

- (XMPPStream *)xmppStream {
    return _xmppStream;
}

- (NSMutableArray *)roomsJoined {
    if (_roomsJoined == nil) {
        _roomsJoined = [[NSMutableArray alloc] init];
    }
    return _roomsJoined;
}


- (void)addStreamDelegate:(id<XMPPStreamDelegate, XMPPRosterDelegate>)aDelegate {
    [self.xmppStream addDelegate:aDelegate delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoster addDelegate:aDelegate delegateQueue:dispatch_get_main_queue()];
}

- (void)removeStreamDelegate:(id<XMPPStreamDelegate, XMPPRosterDelegate>)aDelegate {
    [self.xmppStream removeDelegate:aDelegate];
    [self.xmppRoster removeDelegate:aDelegate];
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


- (XMPPRosterCoreDataStorage *)xmppRosterStorage {
    return _xmppRosterStorage;
}


#pragma mark - 聊天室

- (void)createRoom {
    srand(time(NULL));
    int roomID = rand() % 1000000;
    XMPPJID *roomJID = [XMPPJID jidWithUser:[NSString stringWithFormat:@"%d", roomID] domain:[@"conference." stringByAppendingString:kHostName] resource:nil];
    XMPPRoomCoreDataStorage *roomStorage = [[XMPPRoomCoreDataStorage alloc] init];
    XMPPRoom *room = [[XMPPRoom alloc] initWithRoomStorage:roomStorage jid:roomJID];
    [room activate:_xmppStream];
    [room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [room joinRoomUsingNickname:[[_xmppStream myJID] user] history:nil];
}

-(void)configRoom:(XMPPRoom *)room {
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    
    NSXMLElement *field = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *value = [NSXMLElement elementWithName:@"value"];
    
    NSXMLElement *fieldowners = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *valueowners = [NSXMLElement elementWithName:@"value"];
    
    
    [field addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];  // 永久属性
    [fieldowners addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomowners"];  // 谁创建的房间
    
    
    [field addAttributeWithName:@"type" stringValue:@"boolean"];
    [fieldowners addAttributeWithName:@"type" stringValue:@"jid-multi"];
    
    [value setStringValue:@"1"];
    [valueowners setStringValue:[[_xmppStream myJID] bare]]; //创建者的Jid
    
    [x addChild:field];
    [x addChild:fieldowners];
    [field addChild:value];
    [fieldowners addChild:valueowners];
    
    [room configureRoomUsingOptions:x];
}

#pragma mark - XMPPMUC Delegate

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message {
    NSLog(@"%s", __FUNCTION__);
}


- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message {
    NSLog(@"%s", __FUNCTION__);
}


- (void)xmppMUC:(XMPPMUC *)sender didDiscoverServices:(NSArray *)services {
    NSLog(@"%s", __FUNCTION__);
}

- (void)xmppMUCFailedToDiscoverServices:(XMPPMUC *)sender withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}


- (void)xmppMUC:(XMPPMUC *)sender didDiscoverRooms:(NSArray *)rooms forServiceNamed:(NSString *)serviceName {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - XMPPRoom Delegate

- (void)xmppRoomDidCreate:(XMPPRoom *)sender {
    NSLog(@"%s", __FUNCTION__);
    [self configRoom:sender];
}


- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
    NSLog(@"%s", __FUNCTION__);
    [self.roomsJoined addObject:sender];
}


- (void)xmppRoomDidLeave:(XMPPRoom *)sender {
    NSLog(@"%s", __FUNCTION__);
    [self.roomsJoined removeObject:sender];
}


- (void)xmppRoomDidDestroy:(XMPPRoom *)sender {
    [self.roomsJoined removeObject:sender];
    NSLog(@"%s", __FUNCTION__);
}

@end
