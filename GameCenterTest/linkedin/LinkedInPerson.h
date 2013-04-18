//
// Created by jve on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface LinkedInPerson : NSObject {
    //id,first-name,last-name,picture-url,headline,positions,num-connections

    NSString *_id;
    NSString *_firstName;
    NSString *_lastName;
    NSURL *_pictureURL;
    NSString *_headline;
    NSNumber *_connections;
}



@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *firstName;
@property(nonatomic, copy) NSString *lastName;
@property(nonatomic, strong) NSURL *pictureURL;
@property(nonatomic, copy) NSString *headline;
@property(nonatomic, strong) NSNumber *connections;

- (id)initWithId:(NSString *)id firstName:(NSString *)firstName lastName:(NSString *)lastName pictureURL:(NSURL *)pictureURL headline:(NSString *)headline connections:(NSNumber *)connections;

+ (id)objectWithId:(NSString *)id firstName:(NSString *)firstName lastName:(NSString *)lastName pictureURL:(NSURL *)pictureURL headline:(NSString *)headline connections:(NSNumber *)connections;


@end