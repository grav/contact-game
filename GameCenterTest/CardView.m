//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "CardView.h"
#import "ReactiveCocoa/ReactiveCocoa.h"


@interface CardView ()
@end

@implementation CardView {

}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        CGRect subFrame = CGRectMake(1,1,frame.size.width-2,frame.size.height-2);
        UIView *subView = [[UIView alloc] initWithFrame:subFrame];
        subView.backgroundColor = [UIColor yellowColor];
        [self addSubview:subView];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,subFrame.size.width,40)];
        l.backgroundColor = [UIColor clearColor];
        [subView addSubview:l];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:11];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50,subFrame.size.width, subFrame.size.height-50)];
        [subView addSubview:iv];

        [RACAble(self.card) subscribeNext:^(Card *c) {
            l.text = c.contactName;
            NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:c.imageUrl]];
            iv.image = [[UIImage alloc] initWithData:d];
        }];
    }

    return self;
}

@end