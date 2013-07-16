//
//  AppDelegate.m
//  jobsearch
//
//  Created by CHAN on 13. 5. 30..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import "AppDelegate.h"

#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "ViewController.h"

#import "Baas.h"

#import "KeychainItemWrapper.h"
#import "OpenUDID.h"

@implementation AppDelegate

+ (void)initialize {
    // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPod; U; CPU iPhone OS 3_1_3 like Mac OS X; ko-kr) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7E18 Safari/528.16", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSDictionary *data = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (data != nil) {
        // 푸시로 앱 실행된 경우 푸시 메시지 처리 메소드에 값 넘겨줌.
        [self application:application didReceiveRemoteNotification:data];
    }
	
	[Baasio setApplicationInfo:@"appbox" applicationName:@"jobsearch"];
	
	application.applicationIconBadgeNumber = 0;
    
    self.jobkorea = [[JOBKOREA alloc] init];
    
    self.keyword = @"";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    }else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    self.leftMenuViewController = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];

    self.rightMenuViewController = [[RightMenuViewController alloc] initWithNibName:@"RightMenuViewController" bundle:nil];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:navigationController
                                             leftDrawerViewController:self.leftMenuViewController
                                             rightDrawerViewController:self.rightMenuViewController];
//    [drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
	self.HUD = [[MBProgressHUD alloc] initWithView:navigationController.view];
	[navigationController.view addSubview:self.HUD];

	
	
//	BaasioEntity *entity = [BaasioEntity entitytWithName:@"test"];
//    [entity setObject:@"5g3534" forKey:@"34g534"];
//    
//    [entity saveInBackground:^(BaasioEntity *entity){
//		NSLog(@"%@", entity);
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"POST가 성공하였습니다.\n데이터 브라우저에서 확인해보세요!"
//															message:nil
//														   delegate:nil
//												  cancelButtonTitle:@"OK"
//												  otherButtonTitles:nil];
//		[alertView show];
//		
//	}
//                failureBlock:^(NSError *error){
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"로그인에 실패하였습니다.\n다시 시도해주세요."
//                                                                        message:error.localizedDescription
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"OK"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
//                }];
	

    NSLog(@"UUID : %@", [self getUuid]);
    
    if ([[self getUuid] length] < 10) {
//		[self setUuid:[OpenUDID value]];
		[self setUuid:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        [self onReg];
    }else {
        [self onLogin];
    }
    
//	BaasioPush *push = [[BaasioPush alloc] init];
//	BaasioMessage *message = [[BaasioMessage alloc]init];
//	message.alert = @"안녕";
//	message.to = [NSMutableArray arrayWithObject:@"851de710-ca80-11e2-b3ad-06f4fe0000b5"];
//	
//	[push sendPushInBackground:message
//				  successBlock:^(void) {
//					  NSLog(@"success.");
//				  }
//				  failureBlock:^(NSError *error) {
//					  NSLog(@"fail : %@", error.localizedDescription);
//				  }];
    
    self.window.rootViewController = self.drawerController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [BaasioUser signOut];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self onLogin];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark APNS

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	
	NSMutableString *deviceId = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
	
    for(int i = 0 ; i < 32 ; i++)
    {
        [deviceId appendFormat:@"%02x", ptr[i]];
    }
    BaasioPush *push = [[BaasioPush alloc] init];
    NSArray *tags = @[@"male"];
    NSString *deviceIDString = [NSString stringWithFormat:@"%@",deviceId];
    [push registerInBackground:deviceIDString
                          tags: (NSArray *)tags
                  successBlock:^{
                      NSLog(@"푸시 등록");
				  } failureBlock:^(NSError *error) {
					  NSLog(@"%@", error);
				  }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
	NSLog(@"remote notification: %@",[userInfo description]);
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
	
	NSString *alert = [apsInfo objectForKey:@"alert"];
	NSLog(@"Received Push Alert: %@", alert);
	
//	UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"일자리찾기" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//	[alert2 show];
	
	//	NSString *sound = [apsInfo objectForKey:@"sound"];
	//	NSLog(@"Received Push Sound: %@", sound);
    //	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	
	//	NSString *badge = [apsInfo objectForKey:@"badge"];
	//	NSLog(@"Received Push Badge: %@", badge);
	application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
	
    [self showTextOnly:alert];

}

-(NSString*) getUuid
{
	KeychainItemWrapper * uuidKeychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"uuid" accessGroup:nil];
	return [uuidKeychain objectForKey:(__bridge id)kSecValueData];
}

-(void) setUuid:(NSString*)uuid
{
	KeychainItemWrapper * uuidKeychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"uuid" accessGroup:nil];
	[uuidKeychain setObject:uuid forKey:(__bridge id)kSecValueData];
}

-(void) onReg
{
    UIDevice *dev = [UIDevice currentDevice];
    [BaasioUser signUpInBackground:[self getUuid]
                          password:[self getUuid]
                              name:dev.name
                             email:[self getUuid]
                      successBlock:^(void){
                          NSLog(@"아이디 등록 성공");
                          [self onLogin];
                      }
                      failureBlock:^(NSError *error){
                          NSLog(@"%@", error);
//                          [self onReg];
                      }];
}

-(void) onLogin
{
    [BaasioUser signInBackground:[self getUuid]
                        password:[self getUuid]
                    successBlock:^(void){
                        NSLog(@"로그인 성공");
//                        if ([[[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID] length] < 10) {
                            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
  //                      }
                        
                        if ([[[BaasioUser currentUser] objectForKey:@"AREA"] length] == 0) {
                            BaasioUser *user = [BaasioUser currentUser];
                            [user setObject:@"N" forKey:@"PUSH"];
                            [user setObject:@"0" forKey:@"SEX"];
                            [user setObject:@"0" forKey:@"PAY"];
                            [user setObject:@"0" forKey:@"CTYPE"];
                            [user setObject:@"0" forKey:@"MCAREERCHK"];
                            [user setObject:@"0" forKey:@"JTYPE"];
                            [user setObject:@"0" forKey:@"GI_Part_No"];
                            [user setObject:@"0" forKey:@"AREA"];
                            [user setObject:@"0" forKey:@"P_GI_Part_No"];
                            [user setObject:@"0" forKey:@"P_AREA"];
                            [user updateInBackground:^(BaasioUser *group) {
                                [self loginOK];
                            } failureBlock:^(NSError *error) {
                                NSLog(@"%@", error);
                                [self loginOK];
                            }];
                        }else {
                            [self loginOK];
                        }

                    }
                    failureBlock:^(NSError *error){
                        NSLog(@"%@", error);
//                        [self onReg];
                    }];
}

- (void) loginOK
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appLoginFinishNotification" object:nil];
}

- (void)showTextOnly:(NSString*)message {
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.detailsLabelText = message;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:3];
}

@end
