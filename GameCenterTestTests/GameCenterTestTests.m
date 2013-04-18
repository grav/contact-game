//
//  GameCenterTestTests.m
//  GameCenterTestTests
//
//  Created by Mikkel Gravgaard on 12/07/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import "GameCenterTestTests.h"
#import "GameVC.h"
#import "CardService.h"

@implementation GameCenterTestTests
{
    GameVC *_game;
}
- (void)setUp
{
    [super setUp];

    _game = [[GameVC alloc] init];

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCard
{
    Card *a = [Card cardWithName:@"Foo" connections:10 endorsements:10];
    Card *b = [Card cardWithName:@"Bar" connections:10 endorsements:20];
    Result r = [GameVC compareOwnCard:a withOtherCard:b consideringProperty:@"connections"];
    STAssertEquals(r, ResultTie, @"Tie");
    r = [GameVC compareOwnCard:a withOtherCard:b consideringProperty:@"endorsements"];
    STAssertEquals(r, ResultLoss, @"Loss");
}

@end
