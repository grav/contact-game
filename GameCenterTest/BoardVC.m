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
#import "CardServiceImpl.h"
//#import "UIControl+RACSignalSupport.h"

@implementation BoardVC {
    id <CardService> _cardService;
}
- (id)initWithGame:(Game *)game {
    self = [super init];
    if (self) {
        self.game = game;
        _cardService = [[CardServiceImpl alloc] init];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 320, 50)];
    l.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:l];
    [RACAble(self.game.score) subscribeNext:^(NSNumber *n) {
        l.text = [NSString stringWithFormat:@"Score: %@", n];
    }];
    self.game.score = 0;

    l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    l.text = @"Selected:";
    l.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:l];

    l = [[UILabel alloc] initWithFrame:CGRectMake(320 - 150, 0, 150, 50)];
    l.text = @"Received:";
    l.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:l];

    UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b.frame = CGRectMake(20, 380, 320 - 40, 60);
    [b setTitle:@"Pick a card" forState:UIControlStateNormal];
    [self.view addSubview:b];

    [[b rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.game.receivedCard && self.game.selectedCard) {
            self.game.receivedCard = nil;
            self.game.selectedCard = nil;
        }
        [_cardService newCardWithCompletion:^(Card *card) {
            self.game.selectedCard = card;

            if(self.game.willSelectProperty){
                NSArray *properties = [card.properties allKeys];
                int index = rand() % properties.count;
                [card selectProperty:[properties objectAtIndex:(NSUInteger) index]];
                [self.game performSelector:@selector(setSelectedCard:) withObject:card afterDelay:2];
            }

        }];
    }];


    RAC(b, enabled) = [RACSignal combineLatest:@[RACAble(self.game.selectedCard), RACAble(self.game.receivedCard)]
                                        reduce:^(Card *own, Card *other) {
                                            return @((own == nil && other != nil) || (own != nil && other != nil));
                                        }];

    // 320 x 480

    CardView *received = [[CardView alloc] initWithFrame:CGRectMake(320 - 150 - 20, 60, CARDVIEW_WIDTH, CARDVIEW_HEIGHT)];
    [self.view addSubview:received];
    received.transform = CGAffineTransformMakeRotation((CGFloat) (M_PI_4/ 7.5));

    CGFloat scaleFactor = CARDVIEW_WIDTH / CARDVIEW_WIDTH_LARGE;
    CardView *selectedView = [[CardView alloc] initWithFrame:CGRectMake(15, 50, CARDVIEW_WIDTH_LARGE, CARDVIEW_HEIGHT*(1.0/scaleFactor))];
    [self.view addSubview:selectedView];
    [RACAble(self.game.selectedCard) subscribeNext:^(Card *c) {
        NSLog(@"Selected: \n%@", c);
        selectedView.card = c;
        CGFloat scale;
        CGFloat angle;
        CGPoint center;
        CGFloat animationDuration;
        if (!c.selectedProperty) {
            scale = 1.0;
            angle = 0;
            center = CGPointMake(self.view.center.x, self.view.center.y-50);
            animationDuration = 0.0;
        } else {
            scale = scaleFactor;
            angle = (CGFloat) (-M_PI_4 / 8.0);
            center = CGPointMake(90, 180);
            animationDuration = 0.3;
        }

        [UIView animateWithDuration:animationDuration animations:^{
            CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(angle);
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
            selectedView.center = center;
            selectedView.transform = CGAffineTransformConcat(rotateTransform, scaleTransform);
        }];
    }];

    [RACAble(self.game.receivedCard) subscribeNext:^(Card *c) {
        NSLog(@"Received: \n%@", c);
        received.card = c;
        if(!self.game.willSelectProperty){
            NSCAssert(c.selectedProperty,@"%@",c);
            self.game.selectedCard = [self.game.selectedCard selectProperty:c.selectedProperty];
        }

    }];
}
@end