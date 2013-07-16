//
//  RightMenuViewController.m
//  jobsearch
//
//  Created by CHAN on 13. 6. 1..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import "RightMenuViewController.h"

#import "AppDelegate.h"

#import "RPCDTableViewController.h"
#import "AREATableViewController.h"

#import "CQMFloatingController.h"

#import "Baas.h"

@interface RightMenuViewController ()

@end

@implementation RightMenuViewController

AppDelegate *app;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    app = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOK:)
                                                 name:@"appLoginFinishNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loginOK:(NSNotification*)noti
{
    NSLog(@"RightMenuViewController Login OK");
    if ([[[BaasioUser currentUser] objectForKey:@"PUSH"] isEqualToString:@"Y"]) {
        [self.pushSwitch setSelected:YES];
    }else {
        [self.pushSwitch setSelected:NO];
    }
    
    [self.RPCDButton setTitle:[[app.jobkorea.GI_Part_No objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"P_GI_Part_No"] intValue]] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.AREAButton setTitle:[[app.jobkorea.AREA objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"P_AREA"] intValue]] objectForKey:@"name"] forState:UIControlStateNormal];
}

- (IBAction)onPushSwitch:(id)sender {
    BOOL push = [(UISwitch*)sender isSelected];
    if (!push) {
            BaasioUser *user = [BaasioUser currentUser];
            [user setObject:@"N" forKey:@"PUSH"];
            [user updateInBackground:^(BaasioUser *group) {
                [(UISwitch*)sender setSelected:NO];
            } failureBlock:^(NSError *error) {
                NSLog(@"%@", error);
                [(UISwitch*)sender setSelected:YES];
            }];
    }else {
            BaasioUser *user = [BaasioUser currentUser];
            [user setObject:@"Y" forKey:@"PUSH"];
            [user updateInBackground:^(BaasioUser *group) {
                [(UISwitch*)sender setSelected:YES];
            } failureBlock:^(NSError *error) {
                NSLog(@"%@", error);
                [(UISwitch*)sender setSelected:NO];
            }];
    }
}

- (IBAction)onRPCD:(id)sender {
    
    app.PUSH = YES;
    
    // 1. Prepare a content view controller
	RPCDTableViewController *demoViewController = [[RPCDTableViewController alloc] init];
	
	// 2. Get shared floating controller
	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    
	[demoViewController setFloatingController:floatingController];
    
	// 3. Show floating controller with specified content
	UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
	[floatingController showInView:[rootViewController view]
		 withContentViewController:demoViewController
						  animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noMove" object:nil];
}

- (IBAction)onAREA:(id)sender {
    
    app.PUSH = YES;
    
    // 1. Prepare a content view controller
	AREATableViewController *demoViewController = [[AREATableViewController alloc] init];
	
	// 2. Get shared floating controller
	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    
	[demoViewController setFloatingController:floatingController];
    
	// 3. Show floating controller with specified content
	UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
	[floatingController showInView:[rootViewController view]
		 withContentViewController:demoViewController
						  animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noMove" object:nil];
}

@end
