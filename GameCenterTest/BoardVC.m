//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BoardVC.h"
#import "StubCardService.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "CardView.h"
#import "ReactiveCocoa/UIControl+RACSignalSupport.h"
//#import "UIControl+RACSignalSupport.h"

@implementation BoardVC {
    id<CardService> _cardService;
}
- (id)initWithGame:(Game*)game {
    self = [super init];
    if (self) {
        self.game = game;
        _cardService = [[StubCardService alloc] init];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 250,320, 50)];
    l.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:l];
    [RACAble(self.game.score) subscribeNext:^(NSNumber *n) {
        l.text = [NSString stringWithFormat:@"Score: %@",n];
    }];
    self.game.score = 0;

    l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    l.text = @"Selected:";
    l.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:l];

    l = [[UILabel alloc] initWithFrame:CGRectMake(320-150, 0, 150, 50)];
    l.text = @"Received:";
    l.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:l];

    UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b.frame = CGRectMake(20, 380, 320-40, 60);
    [b setTitle:@"Pick a card" forState:UIControlStateNormal];
    [self.view addSubview:b];

    [[b rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [_cardService newCardWithCompletion:^(Card *card) {
            card.selectedProperty = @"endorsements";
            [self.game didSelectCard:card];
        }];
    }];


    RAC(b, enabled) = [RACSignal combineLatest:@[RACAble(self.game.selectedCard),RACAble(self.game.receivedCard)]
    reduce:^(Card *own, Card *other){
        return @((own==nil && other!=nil ) || (own!=nil && other!=nil));
    }];

    // 320 x 480
    CardView *selected = [[CardView alloc] initWithFrame:CGRectMake(15,50,150, 200)];
    [self.view addSubview:selected];
    selected.transform = CGAffineTransformMakeRotation((CGFloat) (-M_PI_4/8.0));

    CardView *received = [[CardView alloc] initWithFrame:CGRectMake(320-150-20,50,150, 200)];
    [self.view addSubview:received];
    received.transform = CGAffineTransformMakeRotation((CGFloat) (M_PI_4/7.5));

    [RACAble(self.game.selectedCard) subscribeNext:^(Card *c) {
        NSLog(@"Selected: \n%@",c);
        selected.card = c;
    }];

    [RACAble(self.game.receivedCard) subscribeNext:^(Card *c) {
        NSLog(@"Received: \n%@",c);
        received.card = c;
    }];



}
@end