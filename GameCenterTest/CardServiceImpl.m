//
// Created by jve on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CardServiceImpl.h"
#import "LinkedInService.h"
#import "LinkedInConstants.h"
#import "TSMessage.h"



@implementation CardServiceImpl {

}
- (void)newCardWithCompletion:(void (^)(Card *))completion {
    [[LinkedInService singleton] getLinkedInPerson:^(LinkedInPerson *person) {
        Card *card = [Card cardWithName:[NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName] headline:person.headline imageUrl:person.pictureURL.absoluteString connections:person.connections monthOfEmployment:person.monthOfEmployment];
        completion(card);
    }                                   andFailure:^(NSError *error) {
        NSLog(@"Could not get linked in connectio %@", error);
    }];
}



- (void)getUser:(void (^)(LinkedInPerson *))completion andFailure:(void (^)(NSError *))failure {
    [[LinkedInService singleton] getUser:^(LinkedInPerson *person) {
        completion(person);
    }                         andFailure:^(NSError *error) {
        failure(error);
    }];

}


@end
