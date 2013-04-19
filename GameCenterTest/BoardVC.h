//
// Created by Mikkel Gravgaard on 18/04/13.
// Copyright (c) 2013 Betafunk. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Game.h"
#import "ConnectVC.h"

static CGFloat const CARDVIEW_WIDTH = 150;
static CGFloat const CARDVIEW_WIDTH_LARGE = 200;

static CGFloat const CARDVIEW_HEIGHT = 200;

@interface BoardVC : UIViewController

@property (nonatomic, strong) Game *game;

- (id)initWithGame:(Game*)game;

@end