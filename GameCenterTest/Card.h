//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface Card : NSObject
@property (nonatomic, strong) NSDictionary *properties;
@property (nonatomic, strong) NSString *selectedProperty;
@property (nonatomic, strong) NSString *contactName;
+ (Card*)cardWithName:(NSString *)name connections:(int)connections endorsements:(int)endorsements;


- (BOOL)winsOverCard:(Card*)car consideringProperty:(NSString*)property;

@end