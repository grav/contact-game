//
// Created by jve on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CardServiceImpl.h"
#import "LinkedInService.h"


@implementation CardServiceImpl {

}
- (void)newCardWithCompletion:(void (^)(Card *))completion {
    [[LinkedInService singleton] getLinkedInPerson:^(LinkedInPerson *person) {
        Card *card = [Card cardWithName:[NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName] headline:person.headline imageUrl:person.pictureURL.absoluteString connections:person.connections.intValue];
        completion(card);
    }                                   andFailure:^(NSString *error) {
        NSLog(@"Could not get linked in connectio %@", error);
    }];
}


@end