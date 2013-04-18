//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Game.h"

@implementation Game {

}

- (void)determineScore {
    NSString *selectedProperty = self.selectedCard.selectedProperty ? self.selectedCard.selectedProperty : self.receivedCard.selectedProperty;
    Result result = [Game compareOwnCard:self.selectedCard withOtherCard:self.receivedCard consideringProperty:selectedProperty];
    self.score += [Game scoreFromResult:result];
}

- (void)didSelectCard:(Card *)card {
    NSCAssert(!self.selectedCard, @"A card is already selected!");
    self.selectedCard = card;
    if (self.receivedCard) {
        [self determineScore];
    }

    // todo - send card to other player
}


- (void)didReceiveCard:(Card *)card {
    NSCAssert(!self.receivedCard, @"A card has already been received!");
    self.receivedCard = card;
    if (self.selectedCard) {
        [self determineScore];
    }
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