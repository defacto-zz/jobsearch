//
//  LeftMenuViewController.m
//  jobsearch
//
//  Created by CHAN on 13. 6. 1..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import "LeftMenuViewController.h"

#import "AppDelegate.h"

#import "RPCDTableViewController.h"
#import "AREATableViewController.h"
#import "SEXTableViewController.h"
#import "PAYTableViewController.h"
#import "CTYPETableViewController.h"
#import "MCAREERCHKTableViewController.h"
#import "JTYPETableViewController.h"

#import "CQMFloatingController.h"

#import "Baas.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchClose)
                                                 name:@"searchClose" object:nil];
    [self.optionScrollView setContentSize:CGSizeMake([self.optionScrollView contentSize].width, [self.optionScrollView frame].size.height)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loginOK:(NSNotification*)noti
{
    NSLog(@"LeftMenuViewController Login OK");
    [self.RPCDButton setTitle:[[app.jobkorea.GI_Part_No objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"GI_Part_No"] intValue]] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.AREAButton setTitle:[[app.jobkorea.AREA objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"AREA"] intValue]] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.SEXButton setTitle:[[app.jobkorea.SEX objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"SEX"] intValue]] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.PAYButton setTitle:[[app.jobkorea.PAY objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"PAY"] intValue]] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.CTYPEButton setTitle:[[app.jobkorea.CTYPE objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"CTYPE"] intValue]] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.MCAREERCHKButton setTitle:[[app.jobkorea.MCAREERCHK objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"MCAREERCHK"] intValue]] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.JTYPEButton setTitle:[[app.jobkorea.JTYPE objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"JTYPE"] intValue]] objectForKey:@"name"] forState:UIControlStateNormal];
    
}

-(NSString*)getSearch
{
    NSString* search = @"";
    if (![[[self.RPCDButton titleLabel] text] isEqualToString:@"전체"]) {
        search = [NSString stringWithFormat:@"%@, %@", search, [[self.RPCDButton titleLabel] text]];
    }
    if (![[[self.AREAButton titleLabel] text] isEqualToString:@"전체"]) {
        search = [NSString stringWithFormat:@"%@, %@", search, [[self.AREAButton titleLabel] text]];
    }
    if (![[[self.SEXButton titleLabel] text] isEqualToString:@"전체"]) {
        search = [NSString stringWithFormat:@"%@, %@", search, [[self.SEXButton titleLabel] text]];
    }
    if (![[[self.PAYButton titleLabel] text] isEqualToString:@"전체"]) {
        search = [NSString stringWithFormat:@"%@, %@", search, [[self.PAYButton titleLabel] text]];
    }
    if (![[[self.CTYPEButton titleLabel] text] isEqualToString:@"전체"]) {
        search = [NSString stringWithFormat:@"%@, %@", search, [[self.CTYPEButton titleLabel] text]];
    }
    if (![[[self.MCAREERCHKButton titleLabel] text] isEqualToString:@"전체"]) {
        search = [NSString stringWithFormat:@"%@, %@", search, [[self.MCAREERCHKButton titleLabel] text]];
    }
    if (![[[self.JTYPEButton titleLabel] text] isEqualToString:@"전체"]) {
        search = [NSString stringWithFormat:@"%@, %@", search, [[self.JTYPEButton titleLabel] text]];
    }
    if ([search length] > 0) {
        if ([[search substringWithRange:NSMakeRange(0, 1)] isEqualToString:@","]) {
            search = [search substringFromIndex:1];
        }
    }
    return search;
}

- (IBAction)onSearch:(id)sender {
    [self searchClose];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Search" object:nil];
    [app.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)onRPCD:(id)sender {
    
    app.PUSH = NO;
    
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
    
    app.PUSH = NO;

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

- (IBAction)onSEX:(id)sender {
    // 1. Prepare a content view controller
	SEXTableViewController *demoViewController = [[SEXTableViewController alloc] init];
	
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

- (IBAction)onPAY:(id)sender {
    // 1. Prepare a content view controller
	PAYTableViewController *demoViewController = [[PAYTableViewController alloc] init];
	
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

- (IBAction)onCTYPE:(id)sender {
    // 1. Prepare a content view controller
	CTYPETableViewController *demoViewController = [[CTYPETableViewController alloc] init];
	
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

- (IBAction)onMCAREERCHK:(id)sender {
    // 1. Prepare a content view controller
	MCAREERCHKTableViewController *demoViewController = [[MCAREERCHKTableViewController alloc] init];
	
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

- (IBAction)onJTYPE:(id)sender {
    // 1. Prepare a content view controller
	JTYPETableViewController *demoViewController = [[JTYPETableViewController alloc] init];
	
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

- (IBAction)onSearchKeyDown:(id)sender {
    [self searchClose];
}

- (void) searchClose
{
    [self.searchBar resignFirstResponder];
    [self.searchKeyDownButton setHidden:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchKeyDownButton setHidden:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchClose];
    app.keyword = [NSString stringWithString:[searchBar text]];
    [self onSearch:nil];
    NSLog(@"Search");
}

@end
