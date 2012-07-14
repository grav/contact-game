//
//  ViewController.m
//  GameCenterTest
//
//  Created by Mikkel Gravgaard on 12/07/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) GKSession *session;
@end

static NSString *kSessionId = @"MySession";

@implementation ViewController
@synthesize displayNameTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setDisplayNameTextField:nil];
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
}

#pragma mark - GKSessionDelegate
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
}

- (void)session:(GKSession *)session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state
{
    NSLog(@"peer: %@ didChangeState: %d",peerID,state);
}

@end
