//
//  Peer.h
//  GameCenterTest
//
//  Created by Mikkel Gravgaard on 14/07/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>


@interface Peer : NSObject
@property (nonatomic,assign) GKPeerConnectionState state;
@property (nonatomic,weak) GKSession *session;
@property (nonatomic,copy) NSString *peerID;
@property (nonatomic,readonly) NSString *displayName;
@property (nonatomic,copy,readonly) NSString *stateString;
- (id)initWithSession:(GKSession*)s peerID:(NSString*)pId;

@end
