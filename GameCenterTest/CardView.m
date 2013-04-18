//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CardView.h"
#import "ReactiveCocoa/ReactiveCocoa.h"


@interface CardView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CardView {

}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,frame.size.width,50)];
        l.backgroundColor = [UIColor clearColor];
        [self addSubview:l];

        [RACAble(self.card) subscribeNext:^(Card *c) {
            l.text = c.contactName;
        }];
    }

    return self;
}

@end