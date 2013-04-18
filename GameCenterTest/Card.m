//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Card.h"

@interface Card ()
@end

@implementation Card {
    NSDictionary *_properties;
}

+ (Card *)cardWithName:(NSString *)name connections:(int)connections endorsements:(int)endorsements {
    Card *c = [[Card alloc] init];
    c.contactName = name;
    c.properties = @{
        @"connections": @(connections),
        @"endorsements": @(endorsements)
    };
    return c;
}

@end