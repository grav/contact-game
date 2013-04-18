//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Game.h"

@implementation Game {

}

- (void)determineScore
{
    NSString *selectedProperty = self.selectedCard.selectedProperty?self.selectedCard.selectedProperty:self.receivedCard.selectedProperty;
    Result result = [Game compareOwnCard:self.selectedCard withOtherCard:self.receivedCard consideringProperty:selectedProperty];
    self.score += [Game scoreFromResult:result];
}

- (void)didSelectCard:(Card *)card
{
    NSCAssert(!self.selectedCard,@"A card is already selected!");
    self.selectedCard = card;
    if(self.receivedCard){
        [self determineScore];
    }

    // todo - send card to other player
}


- (void)didReceiveCard:(Card *)card {
    NSCAssert(!self.receivedCard,@"A card has already been received!");
    self.receivedCard = card;
    if(self.selectedCard){
        [self determineScore];
    }
}



#pragma mark - Util
+ (Result)compareOwnCard:(Card*)own withOtherCard:(Card *)other consideringProperty:(NSString *)property {
    int ownVal = [[own.properties objectForKey:property] intValue];
    int otherVal = [[other.properties objectForKey:property] intValue];
    if(ownVal > otherVal){
        return ResultVictory;
    } else if (otherVal < ownVal){
        return ResultLoss;
    } else {
        return ResultTie;
    }

}

+ (int)scoreFromResult:(Result)result
{
    switch (result){
        case ResultTie: return 1;
        case ResultLoss: return 0;
        case ResultVictory: return 2;
    }
}



@end