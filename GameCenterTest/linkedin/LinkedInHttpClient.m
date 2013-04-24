//
// Created by Jacob von Eyben on 4/24/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <ReactiveCocoa/RACReplaySubject.h>
#import "LinkedInHttpClient.h"
#import "AFJSONRequestOperation.h"
#import "LinkedInAuthenticationViewController.h"


@interface LinkedInHttpClient ()
@property(nonatomic, strong) LinkedInApplication *application;
@end

@implementation LinkedInHttpClient

+ (LinkedInHttpClient *)clientForApplication:(LinkedInApplication *)application {
    LinkedInHttpClient *client = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.linkedin.com"]];
    client.application = application;
    return client;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Content-Type" value:@"application/json"];
        // This is to make AFNetworking format parameters against server as JSON
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    NSLog(@"Using backend URL: %@", url);
    return self;
}

- (RACSignal *)getUser:(NSString *)accessToken {
    NSString *userUrl = [NSString stringWithFormat:@"/v1/people/~:(id,first-name,last-name,picture-url,headline,positions,num-connections)?oauth2_access_token=%@&format=json", accessToken];
    return [self enqueueRequestWithMethod:@"GET" path:userUrl parameters:nil];
}

- (RACSignal *)getAccessToken {
    return [[self getAuthorizationCode] flattenMap:^(NSString *code) {
        return [self getAccessToken:code];
    }];
}

- (RACSignal *)getAccessToken:(NSString *)authorizationCode {
    NSString *accessTokenUrl = @"/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@";
    NSString *url = [NSString stringWithFormat:accessTokenUrl, authorizationCode, self.application.redirectUrl, self.application.clientId, self.application.clientSecret];
    return [self enqueueRequestWithMethod:@"GET" path:url parameters:nil];
}

- (RACSignal *)getAuthorizationCode {
    RACReplaySubject *subject = [RACReplaySubject subject];
    LinkedInAuthenticationViewController *authentiationViewController = [[LinkedInAuthenticationViewController alloc]
            initWithApplication:self.application
            andSuccess:^(NSString *code) {
                [self hideAuthenticateView];
                [subject sendNext:code];
                [subject sendCompleted];
            } andFailure:^(NSError *authenticateError) {
                [self hideAuthenticateView];
                [subject sendError:authenticateError];
            }];
    [self showAuthenticateView:authentiationViewController];
    return subject;
}


- (RACSignal *)enqueueRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [subject sendNext:responseObject];
        [subject sendCompleted];
    }                                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [subject sendError:error];
    }];

    [self enqueueHTTPRequestOperation:operation];
    return subject;
}

- (void)showAuthenticateView:(LinkedInAuthenticationViewController *)authentiationViewController {
    //todo: handle rootViews not being a navigationController
    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootViewController presentModalViewController:authentiationViewController animated:YES];
}

- (void)hideAuthenticateView {
    //todo: handle rootViews not being a navigationController
    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootViewController dismissModalViewControllerAnimated:YES];
}

@end