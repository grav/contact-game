//
// Created by jve on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "LinkedInPerson.h"



@interface LIGLinkedInService : AFHTTPClient

+ (LIGLinkedInService *)singleton;

- (void)getUser:(void (^)(LinkedInPerson *))success andFailure:(void (^)(NSString *))failure;

- (void)getLinkedInPerson:(void (^)(LinkedInPerson *))success andFailure:(void (^)(NSString *))failure;

- (void)logout;
@end