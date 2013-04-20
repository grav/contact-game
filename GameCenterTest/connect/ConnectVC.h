//
//  ConnectVC.h
//  GameCenterTest
//
//  Created by Mikkel Gravgaard on 12/07/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GameKit/GameKit.h>
#import "LinkedInPerson.h"

@interface ConnectVC : UIViewController<GKSessionDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) LinkedInPerson *currentUser;


@end
