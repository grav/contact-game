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
#import "CardService.h"
#import "CardServiceFactory.h"
#import "LinkedInService.h"
#import "LinkedInConstants.h"
#import "TSMessage.h"

@interface ConnectVC ()
@property(nonatomic, strong) GKSession *session;
@property(nonatomic, strong) NSMutableDictionary *peers;
@property(weak, nonatomic) IBOutlet UITableView *table;
@property(weak, nonatomic) IBOutlet UIButton *singlePlayButton;
@property(weak, nonatomic) IBOutlet UIButton *loginStateButton;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) Peer *connectedPeer;
@property(nonatomic, strong) Game *game;
@property(nonatomic) BOOL didInitiateConnection;

@end

static NSString *kSessionId = @"MySession";
static NSTimeInterval kConnectionTimeout = 10;
static NSString *kCellId = @"PeerTableCell";

@implementation ConnectVC {
    LinkedInPerson *currentUser;
}
@synthesize currentUser;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"application.title", @"the title of the application");
    // Do any additional setup after loading the view, typically from a nib.
    self.peers = [NSMutableDictionary dictionary];

    [RACAble(self.currentUser) subscribeNext:^(LinkedInPerson *p) {
        BOOL loggedIn = p != nil;
        NSString *buttonLabel = loggedIn ? [NSString stringWithFormat:@"%@ %@ (logout)", p.firstName, p.lastName] : @"Login to play";
        [self.loginStateButton setTitle:buttonLabel forState:UIControlStateNormal];
        self.singlePlayButton.enabled = loggedIn;
    }];
    [self loginAndPrepareGame];
}

- (void)loginAndPrepareGame {
    //todo: finish the implementation using rac - nearly there
//    [[[LinkedInService singleton] getAccessTokenUsingRac] subscribeNext:^(NSDictionary *accessToken) {
//        [[[LinkedInService singleton] getUserUsingRac:[accessToken objectForKey:@"access_token"]] subscribeNext:^(id x) {
//            NSLog(@"result %@", x);
//        }];
//    } error:^(NSError *error) {
//        self.loginStateButton.enabled = YES;
//        self.currentUser = nil;
//        if ([error.domain isEqualToString:kLinkedInErrorDomain]) {
//            if (error.code == kLinkedInAuthenticationCancelledByUser) {
//                [TSMessage showNotificationInViewController:self
//                                                  withTitle:NSLocalizedString(@"linkedin.login.cancelled.message.header", "Login was cancelled by user message header") withMessage:NSLocalizedString(@"linkedin.login.cancelled.message.description", "Login was cancelled by user message description") withType:TSMessageNotificationTypeWarning];
//            } else {
//                [TSMessage showNotificationInViewController:self
//                                                  withTitle:NSLocalizedString(@"linkedin.login.failed.message.header", "Login failed for unknown reason") withMessage:NSLocalizedString(@"linkedin.login.failed.message.description", "Login failed for unknown reason") withType:TSMessageNotificationTypeError];
//            }
//        } else {
//            NSLog(@"Error %@", [error localizedDescription]);
//        }
//    }];

    self.loginStateButton.enabled = NO;
    [self.loginStateButton setTitle:@"Loggin in..." forState:UIControlStateNormal];
    [[CardServiceFactory getCardService] getUser:^(LinkedInPerson *user) {
        self.loginStateButton.enabled = YES;
        self.currentUser = user;
        [self preparedGame];
    }     andFailure:^(NSError *error) {
        self.loginStateButton.enabled = YES;
        self.currentUser = nil;
        if ([error.domain isEqualToString:kLinkedInErrorDomain]) {
            if (error.code == kLinkedInAuthenticationCancelledByUser) {
                [TSMessage showNotificationInViewController:self
                                                  withTitle:NSLocalizedString(@"linkedin.login.cancelled.message.header", "Login was cancelled by user message header") withMessage:NSLocalizedString(@"linkedin.login.cancelled.message.description", "Login was cancelled by user message description") withType:TSMessageNotificationTypeWarning];
            } else {
                [TSMessage showNotificationInViewController:self
                                                  withTitle:NSLocalizedString(@"linkedin.login.failed.message.header", "Login failed for unknown reason") withMessage:NSLocalizedString(@"linkedin.login.failed.message.description", "Login failed for unknown reason") withType:TSMessageNotificationTypeError];
            }
        } else {
            NSLog(@"Error %@", [error localizedDescription]);
        }
    }];
}

- (void)logout {
    [[LinkedInService singleton] logout];
    self.currentUser = nil;
    self.session = nil;
    [self.peers removeAllObjects];
    [self.table reloadData];

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
    [self setLoginStateButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)preparedGame {
    self.session = [[GKSession alloc] initWithSessionID:kSessionId displayName:[NSString stringWithFormat:@"%@ %@", currentUser.firstName, currentUser.lastName] sessionMode:GKSessionModePeer];
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
    self.didInitiateConnection = YES;
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
    self.didInitiateConnection = NO;
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
            break;
        case GKPeerStateUnavailable:
            [self.peers removeObjectForKey:peerID];
            break;
        case GKPeerStateDisconnected:
            [self.peers removeObjectForKey:peerID];
            if (self.connectedPeer) {
                if ([peerID isEqualToString:self.connectedPeer.peerID]) {
                    //disconnect and stop game
                    self.connectedPeer = nil;
                    [self stopGame];
                }
            }
            break;
        case GKPeerStateConnecting:
            self.table.allowsSelection = NO;
            break;
        case GKPeerStateConnected:
            self.connectedPeer = p;
            [self startGame];
            break;
        default:
            break;
    }
    [self.table reloadData];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    NSCAssert(peer == self.connectedPeer.peerID, @"Peer id %@ and %@ differ", peer, self.connectedPeer.peerID);
    if (self.game.receivedCard && self.game.selectedCard) {
        //apparently, opponent started a new game
        self.game.receivedCard = nil;
        self.game.selectedCard = nil;
    }
    Card *card = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSCAssert(card, @"Card received is nil? %@", card);
    NSLog(@"Received %@", card);
    self.game.receivedCard = card;
}

- (IBAction)singlePlay:(id)sender {
    self.game = [[Game alloc] initAsPropertySelector:YES];
    UIViewController *vc = [[BoardVC alloc] initWithGame:self.game];
    id <CardService> s = [CardServiceFactory getCardService];
    [RACAble(self.game.selectedCard) subscribeNext:^(Card *own) {
        if (own && own.selectedProperty) {
            [s newCardWithCompletion:^(Card *card) {
                self.game.receivedCard = card;
            }];
        }
    }];
    [self presentModalViewController:vc animated:YES];

}

- (IBAction)didPressLoginStateButton:(id)sender {
    NSLog(NSStringFromSelector(_cmd));
    if (self.currentUser) {
        [self logout];
    } else {
        [self loginAndPrepareGame];
    }
}


#pragma mark - Helper
- (void)startGame {
    self.game = [[Game alloc] initAsPropertySelector:self.didInitiateConnection];

    UIViewController *vc = [[BoardVC alloc] initWithGame:self.game];
    [self presentModalViewController:vc animated:YES];
    [[RACAble(self.game.selectedCard) filter:^BOOL(Card *own) {
        return own != nil;
    }] subscribeNext:^(Card *own) {
        if ((!self.game.willSelectProperty && self.game.selectedCard.selectedProperty) ||
                (self.game.willSelectProperty && own.selectedProperty)) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:own];
            [self.session sendData:data toPeers:@[self.connectedPeer.peerID] withDataMode:GKSendDataReliable error:NULL];
        }
    }];
}

- (void)stopGame {
    [self.game quit];
    self.game = nil;
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
