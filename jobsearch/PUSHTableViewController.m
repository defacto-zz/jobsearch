
#import "PUSHTableViewController.h"
#import "AppDelegate.h"
#import "JobCell.h"

@interface PUSHTableViewController ()
@end

@implementation PUSHTableViewController

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
    [self.navigationItem setTitle:@"알림 목록"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
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
    if ([self.pushList count] == 0) {
        return 1;
    }
    return [self.pushList count];
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
    
    if ([self. pushList count] == 0) {
        [cell.companyLabel setText:@""];
        
        [cell.subjectLabel setText:@"검색 결과가 없습니다."];
        
        [cell.endLabel setText:@""];
        
        [cell.subLabel setText:@""];
    }else {
        
        [cell.companyLabel setText:[[[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"C_Name"] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"] stringByReplacingOccurrencesOfString:@"㈔" withString:@"(사)"]];
        
        [cell.subjectLabel setText:[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_Subject"]];
        
        if ([[[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(0, 4)] intValue] > 2050) {
            [cell.endLabel setText:@"~ 채용시"];
        }else {
            //            [cell.endLabel setText:[NSString stringWithFormat:@"~ %@.%@.%@", [[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(0, 4)], [[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(4, 2)], [[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(6, 2)]]];
            [cell.endLabel setText:[NSString stringWithFormat:@"~ %@.%@", [[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(4, 2)], [[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(6, 2)]]];
        }
        
        NSString *GI_Career;
        switch ([[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_Career"] intValue]) {
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
                GI_Career = [NSString stringWithFormat:@"%@년", [[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_Career"]];
                break;
        }
        
        NSString *GI_EDU_CutLine;
        switch ([[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"GI_EDU_CutLine"] intValue]) {
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
        
        NSArray *area = [[[self. pushList objectAtIndex:indexPath.row] objectForKey:@"AreaCode"] componentsSeparatedByString:@","];
        NSLog(@"%@", area);
        for (int i = 0; i < [area count]; i++) {
            if ([[area objectAtIndex:i] isEqualToString:@"0"]) {
                continue;
            }
            [cell.subLabel setText:[NSString stringWithFormat:@"%@ %@", [cell.subLabel text], [app.jobkorea.AREACODE objectForKey:[area objectAtIndex:i]]]];
        }
        
        
        NSLog(@"%@", [self. pushList objectAtIndex:indexPath.row]);
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.floatingController dismissAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_GO" object:[NSNumber numberWithInt:indexPath.row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onMove" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appLoginFinishNotification" object:nil];
}

@end
