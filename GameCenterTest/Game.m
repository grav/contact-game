//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Game.h"

@implementation Game {

}

- (id)initAsPropertySelector:(BOOL)willSelectProperty{
    self = [super init];
    if (self) {
        _willSelectProperty = willSelectProperty;
        [[[RACSignal combineLatest:@[RACAble(self.selectedCard), RACAble(self.receivedCard)]] filter:^BOOL(RACTuple *tuple) {
            return tuple.first && tuple.second && [self getDeteriminingCard].selectedProperty;
        }] subscribeNext:^(RACTuple *tuple) {
            NSLog(@"first: %@\nsecond: %@", tuple.first, tuple.second);
            Card *own = tuple.first;
            Card *other = tuple.second;
            Result result = [Game compareOwnCard:own
                                   withOtherCard:other
                             consideringProperty:[self getDeteriminingCard].selectedProperty];
            self.score += [Game scoreFromResult:result];
        }];
    }

    return self;
}


- (Card*)getDeteriminingCard
{
    return _willSelectProperty?self.selectedCard:self.receivedCard;
}


#pragma mark - Util
+ (Result)compareOwnCard:(Card *)own withOtherCard:(Card *)other consideringProperty:(NSString *)property {
    NSNumber *ownVal = [own.properties objectForKey:property];
    NSNumber *otherVal = [other.properties objectForKey:property];
    if ([ownVal compare:otherVal] == NSOrderedDescending) {
        return ResultVictory;
    } else if ([ownVal compare:otherVal] == NSOrderedAscending) {
        return ResultLoss;
    } else {
        return ResultTie;
    }

}

+ (int)scoreFromResult:(Result)result {
    int score = 0;
    switch (result) {
        case ResultTie:
            score = 1;
            break;
        case ResultLoss:
            score = 0;
            break;
        case ResultVictory:
            score = 2;
            break;
    }
    return score;
}


@end