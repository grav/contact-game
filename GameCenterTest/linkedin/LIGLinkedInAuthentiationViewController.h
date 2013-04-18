//
//  LIGLinkedInAuthentiationViewController.h
//  LinkedInIntegration
//
//  Created by Jacob von Eyben on 4/18/13.
//  Copyright (c) 2013 Trifork A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIGLinkedInViewController.h"

typedef void(^LIGAuthorizationCodeSuccessCallback)(NSString *code);
typedef void(^LIGAuthorizationCodeFailureCallback)(NSString *errorReason);

@interface LIGLinkedInAuthentiationViewController : UIViewController

- (id)initWithSuccess:(LIGAuthorizationCodeSuccessCallback)succes andFailure:(LIGAuthorizationCodeFailureCallback)failure;


@end
