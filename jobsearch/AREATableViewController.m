
#import "AREATableViewController.h"
#import "AppDelegate.h"

@interface AREATableViewController ()
@end

@implementation AREATableViewController

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
    [self.navigationItem setTitle:@"지역"];
    if(app.PUSH) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:[[[BaasioUser currentUser] objectForKey:@"P_AREA"] intValue] inSection:0]  animated:NO scrollPosition:UITableViewScrollPositionTop];
    }else {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:[[[BaasioUser currentUser] objectForKey:@"AREA"] intValue] inSection:0]  animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
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
    return [app.jobkorea.AREA count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }

    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    [[cell textLabel] setText:[[app.jobkorea.AREA objectAtIndex:indexPath.row] objectForKey:@"name"]];

    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    int X = 0;
    if(app.PUSH) {
        X = [[[BaasioUser currentUser] objectForKey:@"P_AREA"] intValue];
    }else {
        X = [[[BaasioUser currentUser] objectForKey:@"AREA"] intValue];
    }
    
    if (indexPath.row == X) {
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
    if(app.PUSH) {
        [user setObject:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"P_AREA"];
        [user setObject:[[app.jobkorea.AREA objectAtIndex:indexPath.row] objectForKey:@"area"] forKey:@"X_AREA"];
    }else {
        [user setObject:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"AREA"];
    }
    
    
    [user updateInBackground:^(BaasioUser *group) {
    } failureBlock:^(NSError *error) {
    }];
    
    [self.floatingController dismissAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onMove" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appLoginFinishNotification" object:nil];
}

@end
