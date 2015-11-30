//
//  XMPPManager.h
//  MyXMPP
//
//  Created by halloworld on 15/11/29.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework.h>
#import "def.h"

@interface XMPPManager : NSObject

+ (instancetype)shareInterface;

- (XMPPStream *)xmppStream;

- (void)addStreamDelegate:(id<XMPPStreamDelegate>)aDelegate;

- (void)connect;

@end
