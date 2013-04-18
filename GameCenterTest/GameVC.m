//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameVC.h"

typedef enum {
    ResultVictory,
    ResultLoss,
    ResultTie
} Result;


@implementation GameVC {

}


- (void)determineScore
{
    assert(self.selectedCard.selectedProperty || self.receivedCard.selectedProperty);
    NSString *selectedProperty = self.selectedCard.selectedProperty?self.selectedCard.selectedProperty:self.receivedCard.selectedProperty;
    Result result = [GameVC compareOwnCard:self.selectedCard withOtherCard:self.receivedCard consideringProperty:selectedProperty]
    self.score += [GameVC scoreFromResult:result];
}

- (void)didSelectCard:(Card *)card
{
    self.selectedCard = card;
    if(self.receivedCard){
        [self determineScore];
    }
}


- (void)didReceiveCard:(Card *)card {
    if(self.selectedCard){
        [self determineScore];
    }
}

- (void)sendCard:(Card *)card {
    if(self.receivedCard){
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