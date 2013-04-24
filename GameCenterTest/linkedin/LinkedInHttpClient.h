//
// Created by Jacob von Eyben on 4/24/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "LinkedInApplication.h"



@interface LinkedInHttpClient : AFHTTPClient

+ (LinkedInHttpClient *)clientForApplication:(LinkedInApplication *)application;

- (RACSignal *)getAccessToken:(NSString *)authorizationCode;

- (RACSignal *)getAuthorizationCode;
@end