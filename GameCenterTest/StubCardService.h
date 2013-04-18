//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Card.h"
#import "CardService.h"

typedef void (^CardBlock)(Card*);

@interface StubCardService : NSObject <CardService>

@end