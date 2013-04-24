//
//  LinkedInAuthenticationViewController.m
//  LinkedInIntegration
//
//  Created by Jacob von Eyben on 4/18/13.
//  Copyright (c) 2013 Trifork A/S. All rights reserved.
//


#import "LinkedInAuthenticationViewController.h"
#import "LinkedInCredentials.h"
#import "LinkedInApplication.h"

@interface LinkedInAuthenticationViewController ()
@property(nonatomic, strong) UIWebView *authenticationWebView;
@property(nonatomic, copy) LIGAuthorizationCodeFailureCallback failureCallback;
@property(nonatomic, copy) LIGAuthorizationCodeSuccessCallback successCallback;
@property(nonatomic, strong) id application;
@end

@interface LinkedInAuthenticationViewController (UIWebViewDelegate) <UIWebViewDelegate>

@end

@implementation LinkedInAuthenticationViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithApplication:(LinkedInApplication *)application andSuccess:(LIGAuthorizationCodeSuccessCallback)success andFailure:(LIGAuthorizationCodeFailureCallback)failure {
    self = [super init];
    if (self) {
        self.application = application;
        self.successCallback = success;
        self.failureCallback = failure;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.authenticationWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.authenticationWebView.delegate = self;
    [self.view addSubview:self.authenticationWebView];

    self.navigationController.navigationBarHidden = YES;


    NSString *linkedIn = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=r_fullprofile%%20r_network&state=foobar&redirect_uri=http://www.trifork.com", LINKEDIN_CLIENT_ID];
    [self.authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedIn]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation LinkedInAuthenticationViewController (UIWebViewDelegate)
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"About to load request: %@", [[request URL] absoluteString]);
    NSString *url = [[request URL] absoluteString];
    if ([url hasPrefix:LINKEDIN_URL_PREFIX]) {
        if ([url rangeOfString:@"error"].location != NSNotFound) {
            BOOL accessDenied = [url rangeOfString:@"the+user+denied+your+request"].location != NSNotFound;
            NSInteger errorCode = accessDenied ? kLinkedInAuthenticationCancelledByUser : kLinkedInAuthenticationFailed;
            NSError *error = [[NSError alloc] initWithDomain:kLinkedInErrorDomain code:errorCode userInfo:[[NSMutableDictionary alloc] init]];
            self.failureCallback(error);
        } else {
            NSString *prefix = @"http://www.trifork.com/?code=";
            NSString *authorizationCode = [url substringWithRange:NSMakeRange([LINKEDIN_CODE_PREFIX length], [url length] - [LINKEDIN_CODE_PREFIX length] - [LINKEDIN_URL_SUFFIX length])];
            self.successCallback(authorizationCode);
        }
        return NO;
    }
    return YES;
}

@end

//https://www.linkedin.com/v1/people/ZMbG5RBJn2:(num-connections)?oauth2_access_token=AQXqkKhzGFH-cqh1nCJem68_3JKqZPS5tFr_lafjDze6Uh3AuPzEZCQyOKeCz8yMiRjeskNJxas9p3DTLlluKQOe8dRET73yxY2U96LdbNY2-gmm0cnc3qv_1wePqoBM9PC-RPmJ__KQW2Zv5-J2J5vGDX5HL_SVX6mNzdEppt0JBO2PkpI