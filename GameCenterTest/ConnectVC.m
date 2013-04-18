//
//  ConnectVC.m
//  GameCenterTest
//
//  Created by Mikkel Gravgaard on 12/07/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import "ConnectVC.h"
#import "Peer.h"
#import "BoardVC.h"
#import <AVFoundation/AVPlayer.h>
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "LinkedInService.h"

@interface ConnectVC ()
@property(nonatomic, strong) GKSession *session;
@property(nonatomic, strong) NSMutableDictionary *peers;
@property(weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) Peer *connectedPeer;
@property(nonatomic, strong) Game *game;
@end

static NSString *kSessionId = @"MySession";
static NSTimeInterval kConnectionTimeout = 10;
static NSString *kCellId = @"PeerTableCell";

@implementation ConnectVC {
    
    __weak IBOutlet UILabel *displayStatusLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.peers = [NSMutableDictionary dictionary];

    displayStatusLabel.text = @"Initializing...";

    [[LinkedInService singleton] getUser:^(LinkedInPerson *user) {
        displayStatusLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        [self preparedGame];
    }                         andFailure:^(NSString *errorMessage) {
        NSLog(@"Error %@", errorMessage);
        displayStatusLabel.text = errorMessage;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSURL *url = [NSURL URLWithString:@"https://dl.dropbox.com/u/339233/jose/ven-tu1.aif.mp3"];
//    self.player = [AVPlayer playerWithURL:url];
//    [self.player play];
//    if(self.player.status == AVPlayerStatusFailed){
//        NSLog(@"%@",self.player.error);
//    }
}

- (void)viewDidUnload {
    [self setTable:nil];
    displayStatusLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)preparedGame {
    self.session = [[GKSession alloc] initWithSessionID:kSessionId displayName:displayStatusLabel.text sessionMode:GKSessionModePeer];
    self.session.delegate = self;
    self.session.available = YES;
    [self.session setDataReceiveHandler:self withContext:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.peers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:kCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellId];
    }
    Peer *p = [self.peers objectForKey:[[self.peers allKeys] objectAtIndex:indexPath.row]];
    cell.textLabel.text = p.displayName;
    cell.detailTextLabel.text = p.stateString;
    return cell;
}

#pragma mark - UITVDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Peer *p = [self.peers objectForKey:[[self.peers allKeys] objectAtIndex:indexPath.row]];
    [self.session connectToPeer:p.peerID withTimeout:kConnectionTimeout];
}


#pragma mark - GKSessionDelegate methods
- (void)         session:(GKSession *)session
connectionWithPeerFailed:(NSString *)peerID
               withError:(NSError *)error {
    NSLog(@"connectionWithPeerFailed: %@, error: %@", peerID, error);
    self.table.allowsSelection = YES;
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    NSLog(@"sessionDidFailWithError: %@", error);
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    NSLog(@"didReceiveConnectionRequestFromPeer: %@", peerID);
    self.table.allowsSelection = NO;
    NSError *e = nil;
    [self.session acceptConnectionFromPeer:peerID error:&e];
}

- (void)session:(GKSession *)session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state {
    Peer *p = [self.peers objectForKey:peerID];
    if (!p) {
        p = [[Peer alloc] initWithSession:self.session peerID:peerID];
        [self.peers setObject:p forKey:peerID];
    }
    p.state = state;

    NSLog(@"peer: %@ didChangeState: %d", p.displayName, p.state);
    switch (p.state) {
        case GKPeerStateAvailable:
//            [self.session connectToPeer:peerID withTimeout:kConnectionTimeout];
            break;
        case GKPeerStateUnavailable:
            [self.peers removeObjectForKey:peerID];
            break;
        case GKPeerStateConnecting:
            self.table.allowsSelection = NO;
            break;
        case GKPeerStateConnected:
            self.connectedPeer = p;
            [self showBoard];
            break;
        default:
            break;
    }
    [self.table reloadData];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    NSCAssert(peer == self.connectedPeer.peerID, @"Peer id %@ and %@ differ", peer, self.connectedPeer.peerID);
    if(self.game.receivedCard && self.game.selectedCard){
        //apparently, opponent started a new game
        self.game.receivedCard = nil;
        self.game.selectedCard = nil;
    }
    self.game.receivedCard = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


#pragma mark - Helper
- (void) showBoard
{
    self.game = [[Game alloc] init];

    UIViewController *vc = [[BoardVC alloc] initWithGame:self.game];
    [self presentModalViewController:vc animated:YES];
    [RACAble(self.game.selectedCard) subscribeNext:^(Card *c) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:c];
        [self.session sendData:data toPeers:@[self.connectedPeer.peerID] withDataMode:GKSendDataReliable error:NULL];

    }];
//    [RACAble(game.receivedCard) subscribeNext:^(Card *c) {
//        NSLog(@"Received: \n%@",c);
////        received.card = c;
//    }];

}

@end
