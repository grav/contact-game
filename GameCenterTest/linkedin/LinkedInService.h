//
// Created by jve on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "LinkedInPerson.h"



@interface LinkedInService : AFHTTPClient
+ (LinkedInService *)singleton;

- (void)getUser:(void (^)(LinkedInPerson *))success andFailure:(void (^)(NSError *))error;

- (void)getLinkedInPerson:(void (^)(LinkedInPerson *))success andFailure:(void (^)(NSError *))failure;

- (void)logout;
@end