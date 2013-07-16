//
//  LeftMenuViewController.h
//  jobsearch
//
//  Created by CHAN on 13. 6. 1..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuViewController : UIViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *optionScrollView;
@property (weak, nonatomic) IBOutlet UIButton *AREAButton;
@property (weak, nonatomic) IBOutlet UIButton *RPCDButton;
@property (weak, nonatomic) IBOutlet UIButton *SEXButton;
@property (weak, nonatomic) IBOutlet UIButton *PAYButton;
@property (weak, nonatomic) IBOutlet UIButton *CTYPEButton;
@property (weak, nonatomic) IBOutlet UIButton *MCAREERCHKButton;
@property (weak, nonatomic) IBOutlet UIButton *JTYPEButton;
@property (weak, nonatomic) IBOutlet UIButton *searchKeyDownButton;

- (IBAction)onSearch:(id)sender;
- (IBAction)onRPCD:(id)sender;
- (IBAction)onAREA:(id)sender;
- (IBAction)onSEX:(id)sender;
- (IBAction)onPAY:(id)sender;
- (IBAction)onCTYPE:(id)sender;
- (IBAction)onMCAREERCHK:(id)sender;
- (IBAction)onJTYPE:(id)sender;
- (IBAction)onSearchKeyDown:(id)sender;

-(NSString*)getSearch;

@end
