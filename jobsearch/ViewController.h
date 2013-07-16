//
//  ViewController.h
//  jobsearch
//
//  Created by CHAN on 13. 5. 30..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JobDetailViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface ViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet UITableView *jobTableView;
@property (weak, nonatomic) IBOutlet UIView *jobDetailVIew;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (strong, nonatomic) IBOutlet UIButton *pushButton;

@property (strong, nonatomic) JobDetailViewController *jobDetailViewController;

@property (strong, nonatomic) NSMutableArray *jobList;

@property (strong, nonatomic) NSArray *pushList;

- (IBAction)onTitle:(id)sender;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
