//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface Card : NSObject <NSCoding>
@property (nonatomic, strong) NSDictionary *properties;
@property (nonatomic, strong, readonly) NSString *selectedProperty;
@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *imageUrl;

- (id)initWithSelectedProperty:(NSString *)selectedProperty;

+ (id)objectWithSelectedProperty:(NSString *)selectedProperty;


+ (Card*)cardWithName:(NSString *)name headline:(NSString *)headline imageUrl:(NSString *)url connections:(NSNumber *)connections monthOfEmployment:(NSNumber *)monthOfEmployment;
- (Card*)selectProperty:(NSString *)propertyName;



@end
