//
//  ViewController.m
//  GameCenterTest
//
//  Created by Mikkel Gravgaard on 12/07/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import "ViewController.h"
#import "Peer.h"
#import <AVFoundation/AVPlayer.h>
@interface ViewController ()
@property (nonatomic,strong) GKSession *session;
@property (nonatomic,strong) NSMutableDictionary *peers;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,strong) AVPlayer *player;
@end

static NSString *kSessionId = @"MySession";
static NSTimeInterval kConnectionTimeout = 10;
static NSString *kCellId = @"PeerTableCell";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.peers = [NSMutableDictionary dictionary];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSURL *url = [NSURL URLWithString:@"https://dl.dropbox.com/u/339233/jose/ven-tu1.aif.mp3"];
//    self.player = [AVPlayer playerWithURL:url];
//    [self.player play];
//    if(self.player.status == AVPlayerStatusFailed){
//        NSLog(@"%@",self.player.error);
//    }
}

- (void)viewDidUnload
{
    [self setDisplayNameTextField:nil];
    [self setTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)didTapInit:(id)sender {
    self.session = [[GKSession alloc] initWithSessionID:kSessionId displayName:self.displayNameTextField.text sessionMode:GKSessionModePeer];
    self.session.delegate = self;
    self.displayNameTextField.enabled = NO;
    self.session.available = YES;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [self.table  dequeueReusableCellWithIdentifier:kCellId];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellId];
    }
    Peer *p = [self.peers objectForKey:[[self.peers allKeys] objectAtIndex:indexPath.row]];
    cell.textLabel.text = p.displayName;
    cell.detailTextLabel.text = p.stateString;
    return cell;
}

#pragma mark - GKSessionDelegate methods
 - (void)session:(GKSession *)session
connectionWithPeerFailed:(NSString *)peerID
       withError:(NSError *)error
{
    NSLog(@"connectionWithPeerFailed: %@, error: %@",peerID,error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    NSLog(@"sessionDidFailWithError: %@",error);
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
    NSLog(@"didReceiveConnectionRequestFromPeer: %@",peerID);
    NSError *e = nil;
    [self.session acceptConnectionFromPeer:peerID error:&e];
}

- (void)session:(GKSession *)session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state
{
    Peer *p = [self.peers objectForKey:peerID];
    if(!p){
        p = [[Peer alloc] initWithSession:self.session peerID:peerID];
        [self.peers setObject:p forKey:peerID];
    }
    p.state = state;

    NSLog(@"peer: %@ didChangeState: %d",p.displayName,p.state);
    switch (p.state) {
        case GKPeerStateAvailable:
            [self.session connectToPeer:peerID withTimeout:kConnectionTimeout];
            break;
        case GKPeerStateUnavailable:
            [self.peers removeObjectForKey:peerID];
        default:
            break;
    }
    [self.table reloadData];
}

@end