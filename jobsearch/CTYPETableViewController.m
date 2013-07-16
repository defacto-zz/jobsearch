
#import "CTYPETableViewController.h"
#import "AppDelegate.h"

@interface CTYPETableViewController ()
@end

@implementation CTYPETableViewController

AppDelegate *app;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    app = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [self.navigationItem setTitle:@"기업형태"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [app.jobkorea.CTYPE count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    [[cell textLabel] setText:[[app.jobkorea.CTYPE objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    if (indexPath.row == [[[BaasioUser currentUser] objectForKey:@"CTYPE"] intValue]) {
        [cell.contentView setBackgroundColor:[UIColor purpleColor]];
        [[cell textLabel] setTextColor:[UIColor whiteColor]];
    }else {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        [[cell textLabel] setTextColor:[UIColor blackColor]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaasioUser *user = [BaasioUser currentUser];
    [user setObject:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"CTYPE"];
    
    [user updateInBackground:^(BaasioUser *group) {
    } failureBlock:^(NSError *error) {
    }];
    
    [self.floatingController dismissAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onMove" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appLoginFinishNotification" object:nil];
}

@end
