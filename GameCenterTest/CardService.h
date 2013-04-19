//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Card.h"
#import "LinkedInPerson.h"

@protocol CardService <NSObject>
- (void)newCardWithCompletion:(void (^)(Card *))completion;
- (void)getUser:(void (^)(LinkedInPerson *))completion;
@end