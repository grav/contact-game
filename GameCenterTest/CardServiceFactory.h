//
// Created by jve on 4/20/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CardService.h"


@interface CardServiceFactory : NSObject

+ (id<CardService>) getCardService;
@end