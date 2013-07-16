//
//  RightMenuViewController.h
//  jobsearch
//
//  Created by CHAN on 13. 6. 1..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *pushSwitch;
@property (weak, nonatomic) IBOutlet UIButton *AREAButton;
@property (weak, nonatomic) IBOutlet UIButton *RPCDButton;
- (IBAction)onRPCD:(id)sender;
- (IBAction)onAREA:(id)sender;
- (IBAction)onPushSwitch:(id)sender;

@end
