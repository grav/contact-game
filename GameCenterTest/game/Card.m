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

- (id)initWithSelectedProperty:(NSString *)selectedProperty {
    self = [super init];
    if (self) {
        _selectedProperty = selectedProperty;
    }

    return self;
}

+ (id)objectWithSelectedProperty:(NSString *)selectedProperty {
    return [[Card alloc] initWithSelectedProperty:selectedProperty];
}


+ (Card *)cardWithName:(NSString *)name headline:(NSString *)headline imageUrl:(NSString *)url connections:(NSNumber *)connections monthOfEmployment:(NSNumber *)monthOfEmployment {
    Card *c = [[Card alloc] init];
    c.contactName = name;
    c.headline = headline;
    c.properties = @{
        @"Connections": connections,
        @"Headline": @(headline.length),
        @"Months Of Employment": monthOfEmployment
    };
    c.imageUrl = url;
    return c;
}

+ (Card *)selectedCard:(NSString *)name headline:(NSString *)headline imageUrl:(NSString *)url properties:(NSDictionary *)properties selectedProperty:(NSString *)selectedProperty {
    Card *c = [[Card alloc] initWithSelectedProperty:selectedProperty];
    c.contactName = name;
    c.headline = headline;
    c.properties = properties;
    c.imageUrl = url;
    return c;
}

- (Card *)selectProperty:(NSString *)propertyName {
    return [Card selectedCard:self.contactName headline:self.headline imageUrl:self.imageUrl properties:self.properties selectedProperty:propertyName];
}


- (NSString *)description{
    return [NSString stringWithFormat:@"<Card>Name: %@\nImage: %@\nProperties: %@\nSelected: %@",_contactName,_imageUrl,_properties,_selectedProperty];
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
    _selectedProperty = [coder decodeObjectForKey:kSelectedProperty];
    self.imageUrl = [coder decodeObjectForKey:kImageUrl];
    return self;
}


@end