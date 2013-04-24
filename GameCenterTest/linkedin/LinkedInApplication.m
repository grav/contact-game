//
// Created by Jacob von Eyben on 4/24/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LinkedInApplication.h"


@implementation LinkedInApplication


- (id)initWithRedirectUrl:(NSString *)redirectUrl clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret {
    self = [super init];
    if (self) {
        self.redirectUrl = redirectUrl;
        self.clientId = clientId;
        self.clientSecret = clientSecret;
    }

    return self;
}

+ (id)applicationWithRedirectUrl:(NSString *)redirectUrl clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret {
    return [[self alloc] initWithRedirectUrl:redirectUrl clientId:clientId clientSecret:clientSecret];
}

@end