//
//  XMPPManager.h
//  MyXMPP
//
//  Created by halloworld on 15/11/29.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework.h>
#import <XMPPRoster.h>
#import <XMPPRosterCoreDataStorage.h>
#import <XMPPRoom.h>
#import <XMPPMUC.h>
#import <XMPPRoomCoreDataStorage.h>
#import "def.h"

@interface XMPPManager : NSObject

+ (instancetype)shareInterface;

- (XMPPStream *)xmppStream;

- (XMPPRoster *)xmppRoster;
- (XMPPRosterCoreDataStorage *)xmppRosterStorage;

- (void)addStreamDelegate:(id<XMPPStreamDelegate, XMPPRosterDelegate>)aDelegate;

- (void)removeStreamDelegate:(id<XMPPStreamDelegate, XMPPRosterDelegate>)aDelegate;

- (void)connect;

- (void)addFriendWithID:(NSString *)friendID;


#pragma mark - 聊天室

- (void)createRoom;

- (NSMutableArray *)roomsJoined;
- (XMPPMUC *)roomMUC;

@end
