//
//  LinkedInAuthenticationViewController.h
//  LinkedInIntegration
//
//  Created by Jacob von Eyben on 4/18/13.
//  Copyright (c) 2013 Trifork A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkedInConstants.h"

typedef void(^LIGAuthorizationCodeSuccessCallback)(NSString *code);

typedef void(^LIGAuthorizationCodeFailureCallback)(NSError *errorReason);

static NSString *const LINKEDIN_URL_SUFFIX = @"&state=foobar";

static NSString *const LINKEDIN_URL_PREFIX = @"http://www.trifork.com/";
static NSString *const LINKEDIN_CODE_PREFIX = @"http://www.trifork.com/?code=";

@interface LinkedInAuthenticationViewController : UIViewController

- (id)initWithSuccess:(LIGAuthorizationCodeSuccessCallback)succes andFailure:(LIGAuthorizationCodeFailureCallback)failure;

@end
