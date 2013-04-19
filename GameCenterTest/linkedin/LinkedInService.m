//
// Created by jve on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LinkedInService.h"
#import "AFNetworking.h"
#import "LinkedInAuthenticationViewController.h"
#import "LinkedInCredentials.h"

@implementation LinkedInService {
    LinkedInPerson *user;
    NSMutableArray *linkedInPersons;
}

int currentMonth;

+ (LinkedInService *)singleton {
    static LinkedInService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LinkedInService alloc] init];

        NSDate *date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
        currentMonth =  [components month] + 12 * [components year];

    });
    return sharedInstance;
}


- (id)init {
    self = [super init];
    if (self) {
        NSString *baseEndpoint = @"https://www.linkedin.com";
        self = [super initWithBaseURL:[NSURL URLWithString:baseEndpoint]];
        if (self) {
            [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
            [self setDefaultHeader:@"Accept" value:@"application/json"];
            [self setDefaultHeader:@"Content-Type" value:@"application/json"];

            // This is to make AFNetworking format parameters against server as JSON
            self.parameterEncoding = AFJSONParameterEncoding;

            linkedInPersons = [[NSMutableArray alloc] init];
        }
        NSLog(@"Using backend URL: %@", baseEndpoint);
        return self;
    }

    return self;
}

- (void)getAccessToken:(NSString *)authorizationCode withSuccess:(void (^)(NSString *))success andFailure:(void (^)(NSError *))failure {
    NSString *authenticateUrl = @"/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=http://www.trifork.com&client_id=%@&client_secret=%@";;
    NSString *url = [NSString stringWithFormat:authenticateUrl, authorizationCode, LINKEDIN_CLIENT_ID, LINKEDIN_CLIENT_SECRET];
    NSDictionary *emptyParameters = [[NSDictionary alloc] init];
    [self getPath:url parameters:emptyParameters success:^(AFHTTPRequestOperation *afRequest, NSDictionary *linkedInResult) {
        success([linkedInResult objectForKey:@"access_token"]);
    }     failure:^(AFHTTPRequestOperation *afRequest, NSError *error) {
        failure(error);
    }];
}

- (void)getLinkedInPersons:(void (^)(NSArray *persons))success andFailure:(void (^) (NSError *error))failure {
    NSString *connectionsUrl = [NSString stringWithFormat:@"https://www.linkedin.com/v1/people/~/connections:(id,first-name,last-name,picture-url,headline,positions,num-connections)?oauth2_access_token=%@&format=json", [self getAccessToken]];
    [self getPath:connectionsUrl parameters:nil success:^(AFHTTPRequestOperation *afRequest, NSDictionary *linkedInResult) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        NSArray *connections = [linkedInResult objectForKey:@"values"];
        for (NSDictionary *person in connections) {
            if ([((NSString *) [person objectForKey:@"id"]) caseInsensitiveCompare:@"private"] != NSOrderedSame) {

                NSNumber *year = [[[[[person objectForKey:@"positions"] objectForKey:@"values"] objectAtIndex:0] objectForKey:@"startDate"] objectForKey:@"year"];
                NSNumber *month = [[[[[person objectForKey:@"positions"] objectForKey:@"values"] objectAtIndex:0] objectForKey:@"startDate"] objectForKey:@"month"];
                int monthOfEmployment = 0;
                if (year != nil) {
                    monthOfEmployment =  currentMonth - ([month intValue] + (12 * year.intValue));
                }

                LinkedInPerson *linkedInPerson = [LinkedInPerson objectWithId:(NSString *) [person objectForKey:@"id"] firstName:[person objectForKey:@"firstName"] lastName:[person objectForKey:@"lastName"] pictureURL:[NSURL URLWithString:[person objectForKey:@"pictureUrl"]] headline:[person objectForKey:@"headline"] connections:[person objectForKey:@"numConnections"] monthOfEmployment:[NSNumber numberWithInt:monthOfEmployment]];
                [result addObject:linkedInPerson];
            }
        }
        success(result);

    }     failure:^(AFHTTPRequestOperation *afRequest, NSError *error) {
        NSLog(@"getLinkedInPersons error: %@", error);
        failure(error);
    }];
}

- (void)getUser:(void (^) (LinkedInPerson *person))success andFailure:(void (^) (NSString *errorReason))failure {
    if (user != nil) {
        success(user);
        return;
    }

    [self getPath:[self getLinkInUserUrl] parameters:nil success:^(AFHTTPRequestOperation *afRequest, NSDictionary *person) {
        LinkedInPerson *linkedInPerson = [LinkedInPerson objectWithId:(NSString *) [person objectForKey:@"id"] firstName:[person objectForKey:@"firstName"] lastName:[person objectForKey:@"lastName"] pictureURL:[NSURL URLWithString:[person objectForKey:@"pictureUrl"]] headline:[person objectForKey:@"headline"] connections:[person objectForKey:@"numConnections"] monthOfEmployment:0];
        success(linkedInPerson);
    }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        LinkedInAuthenticationViewController *authentiationViewController = [[LinkedInAuthenticationViewController alloc]
                initWithSuccess:^(NSString *code) {
                    [self getAccessToken:code withSuccess:^(NSString *accessToken) {
                        [self storeAccessToken:accessToken];
                        [self getPath:[self getLinkInUserUrl] parameters:nil success:^(AFHTTPRequestOperation *afRequest, NSDictionary *person) {
                            LinkedInPerson *linkedInPerson = [LinkedInPerson objectWithId:(NSString *) [person objectForKey:@"id"] firstName:[person objectForKey:@"firstName"] lastName:[person objectForKey:@"lastName"] pictureURL:[NSURL URLWithString:[person objectForKey:@"pictureUrl"]] headline:[person objectForKey:@"headline"] connections:[person objectForKey:@"numConnections"] monthOfEmployment:0];
                            [self hideAuthenticateView];
                            success(linkedInPerson);
                        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self hideAuthenticateView];
                            failure([error description]);
                        }];
                    }         andFailure:^(NSError *authenticateError) {
                        [self hideAuthenticateView];
                        failure([authenticateError description]);
                    }];

                }    andFailure:^(NSString *errorReason) {
                    [self hideAuthenticateView];
                    failure(errorReason);
                }];

        [self showAuthenticateView:authentiationViewController];
    }];


}

- (NSString *)getLinkInUserUrl {
    return [NSString stringWithFormat:@"https://www.linkedin.com/v1/people/~:(id,first-name,last-name,picture-url,headline,positions,num-connections)?oauth2_access_token=%@&format=json", [self getAccessToken]];
}

- (void)getLinkedInPerson:(void (^) (LinkedInPerson *person))success andFailure:(void (^) (NSString *errorReason))failure {
    if ([linkedInPersons count] == 0) {
        [self getLinkedInPersons:^(NSArray *persons) {
            [linkedInPersons addObjectsFromArray:persons];
            success([self getRandomPerson]);
        }             andFailure:^(NSError *error) {
            failure([error description]);
        }];
    } else {
        success([self getRandomPerson]);
    }
}

- (LinkedInPerson *)getRandomPerson {
    return [linkedInPersons objectAtIndex:(NSUInteger) (arc4random() % [linkedInPersons count])];
}

- (void)showAuthenticateView:(LinkedInAuthenticationViewController *)authentiationViewController {
    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootViewController presentModalViewController:authentiationViewController animated:YES];
}

- (void)hideAuthenticateView {
    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)storeAccessToken:(NSString *)accessToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"accessToken"];
    [defaults synchronize];
}

- (NSString *)getAccessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
}

- (void)logout {
    [self storeAccessToken:nil];
    user = nil;
    [linkedInPersons removeAllObjects];
}
@end