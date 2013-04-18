//
//  Peer.m
//  GameCenterTest
//
//  Created by Mikkel Gravgaard on 14/07/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import "Peer.h"
@implementation Peer
{
    NSString *_displayName;
}

+ (NSString *)stateString:(GKPeerConnectionState)state
{
    NSString *stateString;
    switch(state){
        case GKPeerStateAvailable:
            stateString = @"Available";
            break;
        case GKPeerStateConnected:
            stateString = @"Connected";
            break;
        case GKPeerStateConnecting:
            stateString = @"Connecting";
            break;
        case  GKPeerStateDisconnected:
            stateString = @"Disconnected";
            break;
        case GKPeerStateUnavailable:
            stateString = @"Unavailable";
            break;
        default:
            stateString = @"Unknown";
            break;
    }
    return stateString;
}

- (NSString *)stateString
{
    return [Peer stateString:self.state];
}

- (id)initWithSession:(GKSession*)s peerID:(NSString*)pId
{
    self = [super init];
    if(self){
        self.peerID = pId;
        self.session = s;
    }
    return self;
}

- (NSString *)displayName
{
    if(!_displayName){
        _displayName = [self.session displayNameForPeer:self.peerID];
    }
    return _displayName;
}

- (int) intValue
{
    return 2+2;
}


@end
