//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameVC.h"

@implementation GameVC {

}

- (void)determineScore
{
    NSString *selectedProperty = self.selectedCard.selectedProperty?self.selectedCard.selectedProperty:self.receivedCard.selectedProperty;
    Result result = [GameVC compareOwnCard:self.selectedCard withOtherCard:self.receivedCard consideringProperty:selectedProperty];
    self.score += [GameVC scoreFromResult:result];
    self.receivedCard = nil;
    self.selectedCard = nil;
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
    if(self.selectedCard){
        [self determineScore];
    }
}



#pragma mark - Util
+ (Result)compareOwnCard:(Card*)own withOtherCard:(Card *)other consideringProperty:(NSString *)property {
    if([own.properties objectForKey:property] > [other.properties objectForKey:property]){
        return ResultVictory;
    } else if ([own.properties objectForKey:property] < [other.properties objectForKey:property]){
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