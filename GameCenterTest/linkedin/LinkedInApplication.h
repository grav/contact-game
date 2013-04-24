//
// Created by Jacob von Eyben on 4/24/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface LinkedInApplication : NSObject
@property(nonatomic, copy) NSString *redirectUrl;
@property(nonatomic, copy) NSString *clientId;
@property(nonatomic, copy) NSString *clientSecret;
@end