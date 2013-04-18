//
// Created by jve on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LinkedInPerson.h"


@implementation LinkedInPerson {

}
@synthesize id = _id;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize pictureURL = _pictureURL;
@synthesize headline = _headline;
@synthesize connections = _connections;
@synthesize monthOfEmployment = _monthOfEmployment;

- (id)initWithId:(NSString *)id firstName:(NSString *)firstName lastName:(NSString *)lastName pictureURL:(NSURL *)pictureURL headline:(NSString *)headline connections:(NSNumber *)connections monthOfEmployment:(NSNumber *)monthOfEmployment {
    self = [super init];
    if (self) {
        _id = id;
        _firstName = firstName;
        _lastName = lastName;
        _pictureURL = pictureURL;
        _headline = headline;
        _connections = connections;
        _monthOfEmployment = monthOfEmployment;
    }

    return self;
}

+ (id)objectWithId:(NSString *)id firstName:(NSString *)firstName lastName:(NSString *)lastName pictureURL:(NSURL *)pictureURL headline:(NSString *)headline connections:(NSNumber *)connections monthOfEmployment:(NSNumber *)monthOfEmployment {
    return [[LinkedInPerson alloc] initWithId:id firstName:firstName lastName:lastName pictureURL:pictureURL headline:headline connections:connections monthOfEmployment:monthOfEmployment];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@ %@, headline: %@, connections: %@, month: %@", self.firstName, self.lastName, self.headline, self.connections, self.monthOfEmployment];
}


@end