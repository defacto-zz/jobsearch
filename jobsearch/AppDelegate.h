//
//  AppDelegate.h
//  jobsearch
//
//  Created by CHAN on 13. 5. 30..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import "JOBKOREA.h"

#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "MMDrawerController.h"

#import "Baas.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) MBProgressHUD *HUD;

@property (strong, nonatomic) JOBKOREA *jobkorea;
@property (strong, nonatomic) LeftMenuViewController *leftMenuViewController;
@property (strong, nonatomic) RightMenuViewController *rightMenuViewController;

@property (strong, nonatomic) MMDrawerController * drawerController;

@property (strong, nonatomic) NSString *keyword;

@property (assign) BOOL PUSH;

- (void)showTextOnly:(NSString*)message;

@end
