//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Game.h"
#import "ConnectVC.h"

@interface BoardVC : UIViewController

@property (nonatomic, strong) Game *game;
@property (nonatomic, weak) ConnectVC *connectVC;

- (id)initWithGame:(Game*)game;

@end