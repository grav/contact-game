//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BoardVC.h"
#import "CardService.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

@implementation BoardVC {

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.game = [[Game alloc] init];

    [RACAble(self.game.selectedCard) subscribeNext:^(id x) {
        NSLog(@"Selected: \n%@",x);

    }];

    [RACAble(self.game.receivedCard) subscribeNext:^(id x) {
        NSLog(@"Received: \n%@",x);
    }];

    [RACAble(self.game.score) subscribeNext:^(id x) {
        NSLog(@"Score: %@",x);
    }];

    [[CardService sharedInstance] newCardWithCompletion:^(Card *card) {
        card.selectedProperty = @"endorsements";
        [self.game didSelectCard:card];
    }];

    [[CardService sharedInstance] newCardWithCompletion:^(Card *card) {
        [self.game didReceiveCard:card];
    }];
}
@end