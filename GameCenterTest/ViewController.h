//
//  ViewController.h
//  GameCenterTest
//
//  Created by Mikkel Gravgaard on 12/07/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GameKit/GameKit.h>

@interface ViewController : UIViewController<GKSessionDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;

@end
