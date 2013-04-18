//
//  LIGLinkedInAuthentiationViewController.m
//  LinkedInIntegration
//
//  Created by Jacob von Eyben on 4/18/13.
//  Copyright (c) 2013 Trifork A/S. All rights reserved.
//

#import "LIGLinkedInAuthentiationViewController.h"

@interface LIGLinkedInAuthentiationViewController ()


@end

@interface LIGLinkedInAuthentiationViewController (UIWebViewDelegate) <UIWebViewDelegate>

@end

@implementation LIGLinkedInAuthentiationViewController {
    LIGAuthorizationCodeSuccessCallback _successCallback;
    LIGAuthorizationCodeFailureCallback _failureCallback;
    UIWebView *authenticationWebView;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSuccess:(LIGAuthorizationCodeSuccessCallback)succes andFailure:(LIGAuthorizationCodeFailureCallback)failure {
    self = [super init];
    if (self) {
        _successCallback = succes;
        _failureCallback = failure;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    authenticationWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    authenticationWebView.delegate = self;
    [self.view addSubview:authenticationWebView];

    self.navigationController.navigationBarHidden = YES;


    NSString *linkedIn = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=w6q5h81cvh3t&scope=r_fullprofile%20r_network&state=foobar&redirect_uri=http://www.trifork.com";
    [authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedIn]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation LIGLinkedInAuthentiationViewController (UIWebViewDelegate)
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"About to load request: %@", [[request URL] absoluteString]);
    NSString *url = [[request URL] absoluteString];
    NSString *prefix = @"http://www.trifork.com/?code=";
    NSString *suffix = @"&state=foobar";
    if ([url hasPrefix:prefix]) {
        NSLog(@"found prefix");
        if ([url rangeOfString:@"error"].location != NSNotFound) {
            _failureCallback(@"Access denied"); //todo: extract access denied reason from url
        } else {
            NSString *authorizationCode = [url substringWithRange:NSMakeRange([prefix length], [url length] - [prefix length] - [suffix length])];
            _successCallback(authorizationCode);
        }
        return NO;
    }
    return YES;
}

@end

//https://www.linkedin.com/v1/people/ZMbG5RBJn2:(num-connections)?oauth2_access_token=AQXqkKhzGFH-cqh1nCJem68_3JKqZPS5tFr_lafjDze6Uh3AuPzEZCQyOKeCz8yMiRjeskNJxas9p3DTLlluKQOe8dRET73yxY2U96LdbNY2-gmm0cnc3qv_1wePqoBM9PC-RPmJ__KQW2Zv5-J2J5vGDX5HL_SVX6mNzdEppt0JBO2PkpI