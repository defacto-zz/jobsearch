//
//  ViewController.m
//  jobsearch
//
//  Created by CHAN on 13. 5. 30..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import "ViewController.h"

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "Baas.h"

#import "AFNetworking.h"

#import "JobCell.h"

#import "AppDelegate.h"

#import "PUSHTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

AppDelegate *app;
bool first = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"_UIApplicationSystemGestureStateChangedNotification"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      NSLog(@"Status bar pressed!");
                                                      [self.jobTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:@"PUSH_GO"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      NSLog(@"PUSH_GO : %d", [[note object] intValue]);
                                                      if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                                                          [self.navigationController pushViewController:self.jobDetailViewController animated:YES];
                                                          [self.jobDetailViewController setJobDetail:[self.pushList objectAtIndex:[[note object] intValue]]];
                                                      }else {
                                                          [self.jobDetailViewController setJobDetail:[self.pushList objectAtIndex:[[note object] intValue]]];
                                                      }
                                                  }];

    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.jobTableView.bounds.size.height, self.view.frame.size.width, self.jobTableView.bounds.size.height)];
		view.delegate = self;
		[self.jobTableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    app = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:50/255.0 blue:234/255.0 alpha:1];
    
	[self.titleButton setTitle:@"일자리찾기" forState:UIControlStateNormal];
    
	[self.navigationController setNavigationBarHidden:YES];
	
    self.jobList = [[NSMutableArray alloc] init];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOK:)
                                                 name:@"appLoginFinishNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noMove)
                                                 name:@"noMove" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMove)
                                                 name:@"onMove" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nice_reg)
                                                 name:@"Search" object:nil];

    self.pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pushButton setImage:[UIImage imageNamed:@"ic_activity"] forState:UIControlStateNormal];
    [self.pushButton addTarget:self action:@selector(onPushMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.pushButton setFrame:CGRectMake([self.view frame].size.width-88, 0, 44, 44)];
    [self.pushButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	[self.view addSubview:self.pushButton];
    
//    [self nice_reg];
}

-(void) onPushMessage
{
    // 1. Prepare a content view controller
	PUSHTableViewController *demoViewController = [[PUSHTableViewController alloc] init];
	[demoViewController setPushList:self.pushList];
    
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

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.jobDetailViewController == nil) {
        self.jobDetailViewController = [[JobDetailViewController alloc] init];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        }else {
            [self.jobDetailViewController.view setFrame:CGRectMake(0, 0, self.jobDetailVIew.frame.size.width, self.jobDetailVIew.frame.size.height)];
            [self.jobDetailVIew addSubview:self.jobDetailViewController.view];
        }
        
        [self setupLeftMenuButton];
        [self setupRightMenuButton];

    }
}

-(void) noMove
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
//
//    [self.mm_drawerController setLeftDrawerViewController:nil];
//    [self.mm_drawerController setRightDrawerViewController:nil];
}

-(void) onMove
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    [self.mm_drawerController setLeftDrawerViewController:app.leftMenuViewController];
//    [self.mm_drawerController setRightDrawerViewController:app.rightMenuViewController];
}

-(void)setupLeftMenuButton{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 44, 44)];
	[self.view addSubview:leftButton];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

-(void)setupRightMenuButton{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"ic_settings"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setFrame:CGRectMake([self.view frame].size.width-44, 0, 44, 44)];
    [rightButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	[self.view addSubview:rightButton];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loginOK:(NSNotification*)noti
{
    NSLog(@"ViewController Login OK");
    NSLog(@"%@", [BaasioUser currentUser]);
    if (!first) {
        [self nice_reg];
        first = YES;
    }
    
    BaasioUser *user = [BaasioUser currentUser];
    
    BaasioQuery *query = [BaasioQuery queryWithCollection:@"push_histories"];
    [query setCursor:@"cursor"];
    [query setLimit:20];
    //    [query setProjectionIn:@"name, title"];
    [query setOrderBy:@"PushDate" order:BaasioQuerySortOrderDESC];
    [query setWheres:[NSString stringWithFormat:@"To = %@", [user uuid]]];
    [query queryInBackground:^(NSArray *objects) {
        NSLog(@"%@", objects);
        self.pushList = objects;
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    NSLog(@"description : %@", query.description);

}

-(void) nice_reg
{
    [app.HUD setMode:MBProgressHUDModeIndeterminate];
    [app.HUD show:YES];
    
//    BaasioQuery *query = [BaasioQuery queryWithCollection:@"nice_companies"];
//    [query setWheres:@"COMPANY = '(주)세스코'"];
//    [query queryInBackground:^(NSArray *array){
//        NSLog(@"%@", array);
//    }
//                failureBlock:^(NSError *error){
//                    NSLog(@"%@", error);
//                }];
    
    [[self->_refreshHeaderView _lastUpdatedLabel] setText:[app.leftMenuViewController getSearch]];
    
    NSLog(@"%@", app.keyword);
    NSString *url = [NSString stringWithFormat:@"http://www.jobkorea.co.kr/Service_JK/Mobile/JK_App_Data_List.asp?keyword=%@&rpcd=%@&rbcd=%@&area=/%@/0/0/0/0/0/&sex=%@&pay=%@&ctype=%@&mcareerchk=%@&jtype=%@",
                     [app.keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     [[app.jobkorea.GI_Part_No objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"GI_Part_No"] intValue]] objectForKey:@"depth"],
                     [[app.jobkorea.GI_Part_No objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"GI_Part_No"] intValue]] objectForKey:@"major"],
                     [[app.jobkorea.AREA objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"AREA"] intValue]] objectForKey:@"area"],
                     [[app.jobkorea.SEX objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"SEX"] intValue]] objectForKey:@"sex"],
                     [[app.jobkorea.PAY objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"PAY"] intValue]] objectForKey:@"pay"],
                     [[app.jobkorea.CTYPE objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"CTYPE"] intValue]] objectForKey:@"ctype"],
                     [[app.jobkorea.MCAREERCHK objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"MCAREERCHK"] intValue]] objectForKey:@"mcareerchk"],
                     [[app.jobkorea.JTYPE objectAtIndex:[[[BaasioUser currentUser] objectForKey:@"JTYPE"] intValue]] objectForKey:@"jtype"] ];
    NSLog(@"%@", url);
    [app.jobkorea jobkoreaRequest:url handler:^(NSArray *items) {
        //        NSLog(@"%@", items);
        [self.jobList removeAllObjects];
        [self.jobList addObjectsFromArray:items];
        [self.jobTableView reloadData];
        [app.HUD hide:YES];
        if ([self.jobList count] > 0) {
            [self.jobTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            }else {
                [self tableView:self.jobTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
        }
        [self doneLoadingTableViewData];
    }];
    
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jobkorea.co.kr/Service_JK/Mobile/JK_App_Data_List.asp"]];
    //    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
    //        XMLParser.delegate = self;
    //        [XMLParser parse];
    //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
    //        NSLog(@"%@", error);
    //    }];
    //
    //
    //    [operation start];

}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.jobList count] == 0) {
        return 1;
    }
    return [self.jobList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JobCell *cell = (JobCell *)[tableView dequeueReusableCellWithIdentifier:@"JobCell"];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JobCell" owner:self options:nil];
        
        for (id onObject in nib) {
            if ([onObject isKindOfClass:[JobCell class]]) {
                cell = (JobCell *)onObject;
                break;
            }
        }
    }
    
    if ([self.jobList count] == 0) {
        [cell.companyLabel setText:@""];
        
        [cell.subjectLabel setText:@"검색 결과가 없습니다."];
        
        [cell.endLabel setText:@""];
        
        [cell.subLabel setText:@""];
    }else {
    
    [cell.companyLabel setText:[[[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"C_Name"] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"] stringByReplacingOccurrencesOfString:@"㈔" withString:@"(사)"]];
    
    [cell.subjectLabel setText:[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_Subject"]];
    
        if ([[[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(0, 4)] intValue] > 2050) {
            [cell.endLabel setText:@"~ 채용시"];
        }else {
//            [cell.endLabel setText:[NSString stringWithFormat:@"~ %@.%@.%@", [[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(0, 4)], [[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(4, 2)], [[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(6, 2)]]];
            [cell.endLabel setText:[NSString stringWithFormat:@"~ %@.%@", [[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(4, 2)], [[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(6, 2)]]];
        }

        NSString *GI_Career;
        switch ([[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_Career"] intValue]) {
            case 0:
                GI_Career = @"신입";
                break;
                
            case 200:
                GI_Career = @"신입·경력";
                break;
                
            case 220:
                GI_Career = @"경력(년수무관)";
                break;
                
            default:
                GI_Career = [NSString stringWithFormat:@"%@년", [[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_Career"]];
                break;
        }
        
        NSString *GI_EDU_CutLine;
        switch ([[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"GI_EDU_CutLine"] intValue]) {
            case 0:
                GI_EDU_CutLine = @"무관";
                break;
                
            case 1:
                GI_EDU_CutLine = @"초졸";
                break;
                
            case 2:
                GI_EDU_CutLine = @"중졸";
                break;
                
            case 3:
                GI_EDU_CutLine = @"고졸";
                break;
                
            case 4:
                GI_EDU_CutLine = @"전문대졸";
                break;
                
            case 5:
                GI_EDU_CutLine = @"대졸";
                break;
                
            case 6:
                GI_EDU_CutLine = @"대학원졸";
                break;
                
            default:
                break;
        }
        
        [cell.subLabel setText:[NSString stringWithFormat:@"%@ %@↑", GI_Career, GI_EDU_CutLine]];

        NSArray *area = [[[self.jobList objectAtIndex:indexPath.row] objectForKey:@"AreaCode"] componentsSeparatedByString:@","];
        NSLog(@"%@", area);
        for (int i = 0; i < [area count]; i++) {
            if ([[area objectAtIndex:i] isEqualToString:@"0"]) {
                continue;
            }
            [cell.subLabel setText:[NSString stringWithFormat:@"%@ %@", [cell.subLabel text], [app.jobkorea.AREACODE objectForKey:[area objectAtIndex:i]]]];
        }
        

        NSLog(@"%@", [self.jobList objectAtIndex:indexPath.row]);
}
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController:self.jobDetailViewController animated:YES];
        [self.jobDetailViewController setJobDetail:[self.jobList objectAtIndex:indexPath.row]];
    }else {
        [self.jobDetailViewController setJobDetail:[self.jobList objectAtIndex:indexPath.row]];
    }
}

- (IBAction)onTitle:(id)sender {
    [self nice_reg];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	[self nice_reg];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.jobTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}
/*
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
*/
@end
