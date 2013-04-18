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
    Card *_a, *_b;
}
- (void)setUp
{
    [super setUp];

    _a = [Card cardWithName:@"Foo" connections:10 endorsements:10];
    _b = [Card cardWithName:@"Bar" connections:10 endorsements:20];
    _game = [[GameVC alloc] init];

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCard
{
    _b.selectedProperty = @"endorsements";
    Result r = [GameVC compareOwnCard:_a withOtherCard:_b consideringProperty:@"connections"];
    STAssertEquals(r, ResultTie, @"Tie");
    r = [GameVC compareOwnCard:_a withOtherCard:_b consideringProperty:@"endorsements"];
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

}

- (void)testService
{
    [[CardService sharedInstance] newCardWithCompletion:^(Card *card) {
//        NSLog(@"%@",card);
    }];
}

@end
