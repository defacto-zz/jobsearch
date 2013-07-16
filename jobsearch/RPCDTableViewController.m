
#import "RPCDTableViewController.h"
#import "AppDelegate.h"

@interface RPCDTableViewController ()
@end

@implementation RPCDTableViewController

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
    [self.navigationItem setTitle:@"업·직종명"];
    if(app.PUSH) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:[[[BaasioUser currentUser] objectForKey:@"P_GI_Part_No"] intValue] inSection:0]  animated:NO scrollPosition:UITableViewScrollPositionTop];
    }else {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:[[[BaasioUser currentUser] objectForKey:@"GI_Part_No"] intValue] inSection:0]  animated:NO scrollPosition:UITableViewScrollPositionTop];
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
    return [app.jobkorea.GI_Part_No count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    [[cell textLabel] setText:[[app.jobkorea.GI_Part_No objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    
    int X = 0;
    if(app.PUSH) {
        X = [[[BaasioUser currentUser] objectForKey:@"P_GI_Part_No"] intValue];
    }else {
        X = [[[BaasioUser currentUser] objectForKey:@"GI_Part_No"] intValue];
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
        [user setObject:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"P_GI_Part_No"];
        [user setObject:[[app.jobkorea.GI_Part_No objectAtIndex:indexPath.row] objectForKey:@"depth"] forKey:@"X_GI_Part_No"];
    }else {
        [user setObject:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"GI_Part_No"];
    }
    
    [user updateInBackground:^(BaasioUser *group) {
        NSLog(@"%@", group);
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];

    [self.floatingController dismissAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onMove" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appLoginFinishNotification" object:nil];
}

@end
