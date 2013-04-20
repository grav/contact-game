//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BoardVC.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "CardView.h"
#import "CardServiceFactory.h"
#import <Quartzcore/QuartzCore.h>

@implementation BoardVC {
    id <CardService> _cardService;
}
- (id)initWithGame:(Game *)game {
    self = [super init];
    if (self) {
        self.game = game;
        _cardService = [CardServiceFactory getCardService];
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
                Card *cardWithSelection = [card selectProperty:[properties objectAtIndex:(NSUInteger) index]];
                [self.game performSelector:@selector(setSelectedCard:) withObject:cardWithSelection afterDelay:2];
            }

        }];
    }];


    RAC(b, enabled) = [RACSignal combineLatest:@[RACAble(self.game.selectedCard), RACAble(self.game.receivedCard)]
                                        reduce:^(Card *own, Card *other) {
                                            return @((own == nil && other != nil) || (own != nil && other != nil));
                                        }];

    // 320 x 480

    CGRect receivedFrame = CGRectMake(320 - 150 - 20, 60, CARDVIEW_WIDTH, CARDVIEW_HEIGHT);
    CardView *receivedView = [[CardView alloc] initWithFrame:receivedFrame];
    [self.view addSubview:receivedView];

    CGFloat scaleFactor = CARDVIEW_WIDTH / CARDVIEW_WIDTH_LARGE;
    CardView *selectedView = [[CardView alloc] initWithFrame:CGRectMake(15, 50, CARDVIEW_WIDTH_LARGE, CARDVIEW_HEIGHT*(1.0/scaleFactor))];
    [self.view addSubview:selectedView];

    [[RACAble(self.game.selectedCard) filter:^BOOL(Card *own) {
        // we're not receiving nil && we don't select property & we dont yet have a property and we have received a card
        return own && !self.game.willSelectProperty && !own.selectedProperty && self.game.receivedCard;
    }] subscribeNext:^(id x) {
        self.game.selectedCard = [self.game.selectedCard selectProperty:self.game.receivedCard.selectedProperty];
    }];

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

            selectedView.layer.shouldRasterize = YES;
            //selectedView.layer.rasterizationScale = scale; also blures the text on the card
            selectedView.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
            selectedView.clipsToBounds = NO;
            selectedView.layer.masksToBounds = NO;

        }];
    }];

    [RACAble(self.game.receivedCard) subscribeNext:^(Card *other) {
        NSLog(@"Received: \n%@", other);
        receivedView.card = other;
        if(!self.game.willSelectProperty && other){
            NSCAssert(other.selectedProperty,@"No selected property on %@",other);
            self.game.selectedCard = [self.game.selectedCard selectProperty:other.selectedProperty];
        }
        receivedView.frame = CGRectOffset(receivedFrame, 200, 0);
        receivedView.transform = CGAffineTransformMakeRotation((CGFloat) M_PI_2);
        [UIView animateWithDuration:0.3 animations:^{
            receivedView.transform = CGAffineTransformMakeRotation((CGFloat) (M_PI_4/ 7.5));
            receivedView.frame = receivedFrame;
        }];
    }];
}
@end