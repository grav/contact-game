//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CardService.h"
#import "NSArray+Functional.h"



@implementation CardService {
    NSArray *_cards;
}
- (id)init {
    self = [super init];
    if (self) {
        _cards = [CardService stubCards];
    }

    return self;
}


#pragma mark - Class methods


+ (NSArray *)stubCards
{
    srand(1234567894);   // make sure stub data on each client is the same
    NSArray *peeps =
            @[
                    @[@"Mark Zuckerberg",@"mark.jpg"],
                    @[@"Anne Sofie Bille",@"annesofie.jpg"],
                    @[@"Peter Hugo", @"peter.jpg"],
                    @[@"Late Steve Jobs",@"steve.jpg"],
                    @[@"Arbejdsløs Humanist",@"humanist.jpg"]];
    NSArray *cards = [peeps mapUsingBlock:^id(NSArray *peep) {
        int connections = rand() % 100;
        int endorsements = rand() % 100;
        NSString *url = [NSString stringWithFormat:@"http://localhost:8000/%@",[peep objectAtIndex:1]];
        return [Card cardWithName:[peep objectAtIndex:0]
                         imageUrl:url
                      connections:connections
                     endorsements:endorsements];
    }];
    srand((unsigned int) time(NULL)); //'make sure' we don't continue to pick the same cards on both clients
    return cards;
}

- (void)newCardWithCompletion:(CardBlock)completion {
    int numCards = _cards.count;
    Card *c = [_cards objectAtIndex:(NSUInteger) (rand() % numCards)];
    int delay = rand() % 8 + 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
       completion(c);
    });
}


+ (id)sharedInstance
{
  static dispatch_once_t pred = 0;
  __strong static id _sharedObject = nil;
  dispatch_once(&pred, ^{
    _sharedObject = [[self alloc] init];
  });
  return _sharedObject;



}

@end