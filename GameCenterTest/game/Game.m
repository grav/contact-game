//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Game.h"

@interface Game ()
@property(assign, nonatomic) NSInteger noOfRounds;
@property(assign, nonatomic) NSInteger currentRound;

@end

@implementation Game {

}


- (void)setSelectedCard:(Card *)selectedCard {
    _selectedCard = selectedCard;
}

- (void)endRoundWithOwnCard:(Card *)ownCard andOpponentCard:(Card *)opponentCard {
    Result result = [Game compareOwnCard:ownCard
                           withOtherCard:opponentCard
                     consideringProperty:[self getDeteriminingCard].selectedProperty];
    self.score += [Game scoreFromResult:result];
    NSLog(@"updating score to %i", self.score);
    if (self.currentRound >= self.noOfRounds) {
        NSLog(@"the game has ended.");
        //todo: present the total result and make it possible to return to Connect Screen
        self.currentRound = 1;
    } else {
        self.currentRound++;
    }
}

- (id)initAsPropertySelector:(BOOL)willSelectProperty {
    self = [super init];
    if (self) {
        self.noOfRounds = 5;
        self.currentRound = 1;
        _willSelectProperty = willSelectProperty;
        //round is ending and we compare the score
        [[[RACSignal combineLatest:@[RACAble(self.selectedCard), RACAble(self.receivedCard)]] filter:^BOOL(RACTuple *tuple) {
            //we have two cards and a determining property, then we can end the round
            return tuple.first && tuple.second && [self getDeteriminingCard].selectedProperty;
        }] subscribeNext:^(RACTuple *tuple) {
            [self endRoundWithOwnCard:tuple.first andOpponentCard:tuple.second];
        }];
    }
    return self;
}

- (Card *)getDeteriminingCard {
    return _willSelectProperty ? self.selectedCard : self.receivedCard;
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

- (void)quit {
    //implement to do any cleanup of the current game
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