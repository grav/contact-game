//
//  GameCenterTestTests.m
//  GameCenterTestTests
//
//  Created by Mikkel Gravgaard on 12/07/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import "GameCenterTestTests.h"
#import "Game.h"
#import "StubCardService.h"

@implementation GameCenterTestTests
{
    Game *_game;
    Card *_a, *_b;
}
- (void)setUp
{
    [super setUp];
    _a = [Card cardWithName:@"Foo" headline:@"whatever" imageUrl:@"bar" connections:10];
    _b = [Card cardWithName:@"Bar" headline:@"whatever" imageUrl:@"bar" connections:10];
    _game = [[Game alloc] init];

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCard
{
    _b.selectedProperty = @"endorsements";
    Result r = [Game compareOwnCard:_a withOtherCard:_b consideringProperty:@"connections"];
    STAssertEquals(r, ResultTie, @"Tie");
    r = [Game compareOwnCard:_a withOtherCard:_b consideringProperty:@"endorsements"];
    STAssertEquals(r, ResultLoss, @"Loss");
}

- (void)testGame
{
    STAssertEquals(_game.score, 0, @"Initially 0 score");
    _b.selectedProperty = @"endorsements";
    [_game didSelectCard:_b];
    STAssertEquals(_game.score, 0, @"No match yet");
    [_game didReceiveCard:_a];
    STAssertEquals(_game.score, 2, @"Win!");
//    STAssertNil(_game.receivedCard, @"Received card nil'et out");
//    STAssertNil(_game.selectedCard, @"Selected card nil'et out");

}



@end
