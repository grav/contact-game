//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BoardVC.h"
#import "CardService.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "CardView.h"

@implementation BoardVC {

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.game = [[Game alloc] init];

    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 250,320, 50)];
    [self.view addSubview:l];
    [RACAble(self.game.score) subscribeNext:^(NSNumber *n) {
        l.text = [NSString stringWithFormat:@"Score: %@",n];
    }];

    l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    l.text = @"Selected:";
    l.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:l];

    l = [[UILabel alloc] initWithFrame:CGRectMake(320-150, 0, 150, 50)];
    l.text = @"Received:";
    l.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:l];

    // 320 x 480
    CardView *selected = [[CardView alloc] initWithFrame:CGRectMake(0,50,150, 200)];
    [self.view addSubview:selected];

    CardView *received = [[CardView alloc] initWithFrame:CGRectMake(320-150,50,150, 200)];
    [self.view addSubview:received];

    [RACAble(self.game.selectedCard) subscribeNext:^(Card *c) {
        NSLog(@"Selected: \n%@",c);
        selected.card = c;
    }];

    [RACAble(self.game.receivedCard) subscribeNext:^(Card *c) {
        NSLog(@"Received: \n%@",c);
        received.card = c;
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