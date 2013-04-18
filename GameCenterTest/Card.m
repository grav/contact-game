//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Card.h"

#define kContactName @"ContactName"
#define kHeadline @"Headline"
#define kProperties @"Properties"
#define kSelectedProperty @"SelectedProperty"
#define kImageUrl @"ImageUrl"

@interface Card ()
@end

@implementation Card {
    NSDictionary *_properties;
}

+ (Card *)cardWithName:(NSString *)name headline:(NSString *)headline imageUrl:(NSString *)url connections:(NSNumber *)connections monthOfEmployment:(NSNumber *)monthOfEmployment {
    Card *c = [[Card alloc] init];
    c.contactName = name;
    c.headline = headline;
    c.properties = @{
        @"connections": connections,
        @"headline": @(headline.length),
        @"monthOfEmployment": monthOfEmployment
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
    [coder encodeObject:_headline forKey:kHeadline];
    [coder encodeObject:_selectedProperty forKey:kSelectedProperty];
    [coder encodeObject:_imageUrl forKey:kImageUrl];
}

- (id)initWithCoder:(NSCoder *)coder {
    self.properties = [coder decodeObjectForKey:kProperties];
    self.contactName = [coder decodeObjectForKey:kContactName];
    self.headline = [coder decodeObjectForKey:kHeadline];
    self.selectedProperty = [coder decodeObjectForKey:kSelectedProperty];
    self.imageUrl = [coder decodeObjectForKey:kImageUrl];
    return self;
}


@end