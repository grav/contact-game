//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Card.h"


@interface GameVC : UIViewController
@property int score;
@property (nonatomic, strong) Card *selectedCard,*receivedCard;
@property (nonatomic) BOOL willSelectProperty;

- (void)didSelectCard:(Card*)card;

- (void)didReceiveCard:(Card*)card;

- (void)sendCard:(Card*)card;

@end