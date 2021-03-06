//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Card.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

typedef enum {
    ResultVictory,
    ResultLoss,
    ResultTie
} Result;



@interface Game : NSObject
@property int score;
@property (nonatomic, strong) Card *selectedCard,*receivedCard;
@property (nonatomic, readonly) BOOL willSelectProperty;

+ (Result)compareOwnCard:(Card*)own withOtherCard:(Card *)other consideringProperty:(NSString *)property;

- (void)endRound;

- (id)initAsPropertySelector:(BOOL)willSelectProperty;

- (void)quit;
@end