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

- (id)initWithId:(NSString *)id firstName:(NSString *)firstName lastName:(NSString *)lastName pictureURL:(NSURL *)pictureURL headline:(NSString *)headline connections:(NSNumber *)connections {
    self = [super init];
    if (self) {
        _id = id;
        _firstName = firstName;
        _lastName = lastName;
        _pictureURL = pictureURL;
        _headline = headline;
        _connections = connections;
    }

    return self;
}

+ (id)objectWithId:(NSString *)id firstName:(NSString *)firstName lastName:(NSString *)lastName pictureURL:(NSURL *)pictureURL headline:(NSString *)headline connections:(NSNumber *)connections {
    return [[LinkedInPerson alloc] initWithId:id firstName:firstName lastName:lastName pictureURL:pictureURL headline:headline connections:connections];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@ %@, headline: %@, connections: %@", self.firstName, self.lastName, self.headline, self.connections];
}


@end