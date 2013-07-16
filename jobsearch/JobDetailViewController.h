//
//  JobDetailViewController.h
//  jobsearch
//
//  Created by CHAN on 13. 6. 2..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMapView.h"
#import "NMapLocationManager.h"

#define kApiKey @"647b750fd2fe1f8acde0e91ebaaae00e"

@interface JobDetailViewController : UIViewController <NSXMLParserDelegate, UIWebViewDelegate, UIActionSheetDelegate, NMapViewDelegate, NMapPOIdataOverlayDelegate, MMapReverseGeocoderDelegate, NMapLocationManagerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate> {
	
    NMapView *_mapView;
    
	NMapPOIdataOverlay *_mapPOIdataOverlay;
    
	UIToolbar *_toolbar;
    
    NGeoPoint myLocation;
}

@property (weak, nonatomic) IBOutlet UIView *onMapView;
@property (strong, nonatomic) NSDictionary *Job;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (strong, nonatomic) IBOutlet UIWebView *JobWebView;
@property (strong, nonatomic) NSMutableDictionary *nice;
@property (weak, nonatomic) IBOutlet UIButton *niceButton;
@property (strong, nonatomic) NSMutableDictionary *companyInfo;
@property (strong, nonatomic) NSMutableArray *niceArray;

-(void) setJobDetail:(NSDictionary*)Job;
-(IBAction) onHomePage:(id)sender;
- (IBAction)onNice:(id)sender;
- (IBAction)onShare:(id)sender;

@end
