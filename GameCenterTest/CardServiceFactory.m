//
// Created by jve on 4/20/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CardServiceFactory.h"
#import "CardServiceImpl.h"
#import "StubCardService.h"


@implementation CardServiceFactory {

}
+ (id <CardService>)getCardService {
    return [[StubCardService alloc] init];
    //return [[CardServiceImpl alloc] init];
}


@end