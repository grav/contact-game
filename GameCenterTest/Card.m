//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Card.h"

#define kContactName @"ContactName"
#define kProperties @"Properties"
#define kSelectedProperty @"SelectedProperty"

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

- (NSString *)description{
    return [NSString stringWithFormat:@"<Card>Name: %@\nProperties: %@",_contactName,_properties];
}

#pragma mark - NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_properties forKey:kProperties];
    [coder encodeObject:_contactName forKey:kContactName];
    [coder encodeObject:_selectedProperty forKey:kSelectedProperty];
}

- (id)initWithCoder:(NSCoder *)coder {
    self.properties = [coder decodeObjectForKey:kProperties];
    self.contactName = [coder decodeObjectForKey:kContactName];
    self.selectedProperty = [coder decodeObjectForKey:kSelectedProperty];
    return self;
}


@end