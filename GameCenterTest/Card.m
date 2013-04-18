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
#define kImageUrl @"ImageUrl"

@interface Card ()
@end

@implementation Card {
    NSDictionary *_properties;
}

+ (Card *)cardWithName:(NSString *)name imageUrl:(NSString *)url connections:(int)connections endorsements:(int)endorsements {
    Card *c = [[Card alloc] init];
    c.contactName = name;
    c.properties = @{
        @"connections": @(connections),
        @"endorsements": @(endorsements)
    };
    c.imageUrl = url;
    return c;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<Card>Name: %@\nImage: %@\nProperties: %@",_contactName,_imageUrl,_properties];
}

#pragma mark - NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_properties forKey:kProperties];
    [coder encodeObject:_contactName forKey:kContactName];
    [coder encodeObject:_selectedProperty forKey:kSelectedProperty];
    [coder encodeObject:_imageUrl forKey:kImageUrl];
}

- (id)initWithCoder:(NSCoder *)coder {
    self.properties = [coder decodeObjectForKey:kProperties];
    self.contactName = [coder decodeObjectForKey:kContactName];
    self.selectedProperty = [coder decodeObjectForKey:kSelectedProperty];
    self.imageUrl = [coder decodeObjectForKey:kImageUrl];
    return self;
}


@end