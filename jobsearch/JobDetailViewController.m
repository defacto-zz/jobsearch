//
//  JobDetailViewController.m
//  jobsearch
//
//  Created by CHAN on 13. 6. 2..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import "JobDetailViewController.h"

#import "AppDelegate.h"

#import "NMapViewResource.h"

#import "AFNetworking.h"

#import "UIScrollView+APParallaxHeader.h"

#import "SqlManager.h"

#import "DCKakaoActivity.h"
#import "DCLineActivity.h"

#define kMyLocationStr @"내위치"
#define kMapModeStr @"지도보기"
#define kClearMapStr @"초기화"
#define KTestModeStr @"테스트"

#define KMapModeStandardStr @"일반지도"
#define KMapModeSatelliteStr @"위성지도"
#define KMapModeTrafficStr @"실시간교통"
#define KMapModeBicycleStr @"자전거지도"

#define kCancelStr @"취소"

#define kMapInvalidCompassValue (-360)

@interface JobDetailViewController ()

@end

@implementation JobDetailViewController

AppDelegate *app;
NMapPOIdataOverlay *poiDataOverlay;
UISwipeGestureRecognizer *swipeUp;
UISwipeGestureRecognizer *swipeDown;
BOOL webViewScrolledToTop;
BOOL webViewScrolledToBottom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    app = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    self.companyInfo = [[NSMutableDictionary alloc] init];
    self.nice = [[NSMutableDictionary alloc] init];
    self.niceArray = [[NSMutableArray alloc] init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
    }

//    [self.JobWebView.scrollView addParallaxWithImage:[UIImage imageNamed:@"Default"] andHeight:150.0f];
//    swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
//    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
//    swipeUp.delegate = self;
//    [self.JobWebView.scrollView setDelegate:self];
//    [self.JobWebView.scrollView addGestureRecognizer:swipeUp];
//    [self.JobWebView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:swipeUp];
//    swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
//    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
//    swipeDown.delegate = self;
//    [self.JobWebView.scrollView addGestureRecognizer:swipeDown];
//    [self.JobWebView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:swipeDown];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    


}

-(void) onBack
{
//    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onMove" object:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        [self.navigationController setNavigationBarHidden:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noMove" object:nil];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_mapView == nil) {
        _mapView = [[NMapView alloc] initWithFrame:CGRectMake(0, 0, self.onMapView.frame.size.width, self.onMapView.frame.size.height)];
        [_mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];
        [_mapView setReverseGeocoderDelegate:self];
        [_mapView setDelegate:self];
        [_mapView setApiKey:kApiKey];
        
        NMapLocationManager *lm = [NMapLocationManager getSharedInstance];
        
        [_mapView setUserInteractionEnabled:NO];
        
        // set delegate
        [lm setDelegate:self];
        
        // start updating location
        [lm startContinuousLocationInfo];
        
        BOOL isAvailableCompass = [lm headingAvailable];
        if (isAvailableCompass && [lm isTrackingEnabled]) {
//            [_mapView setAutoRotateEnabled:YES];
            
            // start updating heading
//            [lm startUpdatingHeading];
        }
        
        //	[_mapView set]
        [self.onMapView addSubview:_mapView];
        
        NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
        
        poiDataOverlay = [mapOverlayManager createPOIdataOverlay];
        [self.onMapView setFrame:CGRectMake(0, 0, [self.onMapView frame].size.width, [self.onMapView frame].size.height)];
        [self.JobWebView.scrollView addParallaxWithView:self.onMapView andHeight:[self.onMapView frame].size.height];
        
    }
    
//    [poiDataOverlay removeOverlay];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.apistore.co.kr/traffic/appleTree/v1/0/Path/PathSearch_Exit.asp?changeCount=5&optCount=5&resultCount=10&SX=126.897654&SY=37.476946&EX=126.939833&EY=37.519465&OPT=1&output=json&svcid=f78480bc1c06734607e4c7107d0642f3"]];
    [request setValue:@"NDM2LTEzNzA1NjgyNTUwMjgtYjYwMjhhMGQtN2M0Ni00MWY2LTgyOGEtMGQ3YzQ2OTFmNmQ1" forHTTPHeaderField:@"x-waple-authorization"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", error);
    }];
    
    [operation start];
}

-(void)setJobDetail:(NSDictionary*)Job
{
    self.Job = [NSDictionary dictionaryWithDictionary:Job];
	
	[self.companyInfo removeAllObjects];
    
    [self.JobWebView loadHTMLString:@"" baseURL:nil];
	
    [self.niceButton setEnabled:NO];
    [self.nice removeAllObjects];
    
    [self.titleButton setTitle:[[[self.Job objectForKey:@"C_Name"] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"] stringByReplacingOccurrencesOfString:@"㈔" withString:@"(사)"] forState:UIControlStateNormal];
    NSLog(@"%@", [[[self.Job objectForKey:@"C_Name"] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"] stringByReplacingOccurrencesOfString:@"㈔" withString:@"(사)"]);
    
    [self.niceArray removeAllObjects];
    [self.niceArray addObjectsFromArray:getList([[[self.Job objectForKey:@"C_Name"] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"] stringByReplacingOccurrencesOfString:@"㈔" withString:@"(사)"])];
    
    NSLog(@"%@", self.niceArray);
    
    if ([self.niceArray count] > 0) {
        [self.niceButton setHidden:NO];
    }else {
        [self.niceButton setHidden:YES];
    }
    
    [app.HUD show:YES];
    [app.jobkorea GIBWebParse:self.Job handler:^(NSDictionary *webStrs) {
        if ([webStrs objectForKey:@"string1"] || [webStrs objectForKey:@"string2"] || [webStrs objectForKey:@"string3"] || [webStrs objectForKey:@"string5"] || [webStrs objectForKey:@"string4"]) {
            [self.JobWebView loadHTMLString:[NSString stringWithFormat:@"<html lang='ko' class='ua_io'><head>                                             <meta charset='utf-8'>                                             <meta name='viewport' content='width=100%%, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0'>                                             <link type='text/css' rel='stylesheet' href='http://m.jobkorea.co.kr/css/default.css'>                                             <script type='text/javascript' src='http://m.jobkorea.co.kr/include/js/jquery-1.8.3.min.js' style=''></script>                                             <script type='text/javascript' src='http://m.jobkorea.co.kr/include/js/cookie.js'></script>                                             <style type='text/css'>                                             .devLazyLoad li > span {display:none;}                                             .devLazyLoad li > a {display:block;}                                             .devLazyLoad li.on > span {display:block;}                                             .devLazyLoad li.on > a {display:none;}                                             </style>%@%@%@%@<div class='header2'>                                             <h2>상세요강</h2>                                             </div>%@<br><br><br><br><br>", [webStrs objectForKey:@"string1"], [webStrs objectForKey:@"string2"], [webStrs objectForKey:@"string3"], [webStrs objectForKey:@"string5"], [self changeHtml:[webStrs objectForKey:@"string4"]]] baseURL:nil];
        if ([[webStrs objectForKey:@"lng"] doubleValue] > 0) {

            [poiDataOverlay removeOverlay];
        
        [poiDataOverlay initPOIdata:1];
        [poiDataOverlay addPOIitemAtLocation:NGeoPointMake([[webStrs objectForKey:@"lng"] doubleValue], [[webStrs objectForKey:@"lat"] doubleValue]) title:[[[self.Job objectForKey:@"C_Name"] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"] stringByReplacingOccurrencesOfString:@"㈔" withString:@"(사)"] type:NMapPOIflagTypePin iconIndex:0 withObject:nil];

            NSLog(@"%f", [[webStrs objectForKey:@"lng"] doubleValue]);
            NSLog(@"%f", [[webStrs objectForKey:@"lat"] doubleValue]);

        [poiDataOverlay endPOIdata];
        
        [poiDataOverlay showAllPOIdata];
        [poiDataOverlay selectPOIitemAtIndex:0 moveToCenter:NO];
        [_mapView setMapCenter:NGeoPointMake([[webStrs objectForKey:@"lng"] doubleValue], [[webStrs objectForKey:@"lat"] doubleValue]) atLevel:8];
        }
        [app.HUD hide:YES];
        }
    }];
    
//    BaasioQuery *niceQuery = [BaasioQuery queryWithCollection:@"nice_companies"];
//    [niceQuery setWheres:[NSString stringWithFormat:@"COMPANY = '%@'", [[self.Job objectForKey:@"C_Name"] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"]]];
//    [niceQuery queryInBackground:^(NSArray *objects) {
//        NSLog(@"%@", objects);
//        if ([objects count] > 0) {
//            [self.nice addEntriesFromDictionary:[objects objectAtIndex:0]];
//            [self.niceButton setEnabled:YES];
//        }
//    } failureBlock:^(NSError *error) {
//        NSLog(@"%@", error);
//    }];
    
}

-(NSString*)changeHtml:(NSString*)html
{
    [html stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width='100%' height='auto'"];
    return html;
}

- (IBAction)onHomePage:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.jobkorea.co.kr/List_GI/GIB_Read.asp?GI_No=%@", [self.Job objectForKey:@"GI_No"]]]];
}

- (IBAction)onNice:(id)sender {
    NSLog(@"%@", self.nice);
}

- (IBAction)onShare:(id)sender {
    NSString *date = @"~ 채용시";
    if ([[[self.Job objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(0, 4)] intValue] < 2050) {
        date = [NSString stringWithFormat:@"~ %@.%@.%@", [[self.Job objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(0, 4)], [[self.Job objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(4, 2)], [[self.Job objectForKey:@"GI_End_Date"] substringWithRange:NSMakeRange(6, 2)]];
    }
    NSString *body = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", [[[self.Job objectForKey:@"C_Name"] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"] stringByReplacingOccurrencesOfString:@"㈔" withString:@"(사)"], [self.Job objectForKey:@"GI_Subject"], date, [NSString stringWithFormat:@"http://m.jobkorea.co.kr/List_GI/GIB_Read.asp?GI_No=%@", [self.Job objectForKey:@"GI_No"]]];
    
//    for (int i = 0; i < [detailArray count]; i++) {
//        body = [NSString stringWithFormat:@"%@\n\n%@\n%@", body, [[detailArray objectAtIndex:i] objectForKey:@"title"], [[detailArray objectAtIndex:i] objectForKey:@"contents"]];
//    }
    
    NSArray *activityItems;
    
    activityItems = [[NSArray alloc] initWithObjects:body, nil];

    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:?body=%@", [[activityItems objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
        return;
    }
    
    DCKakaoActivity *kakaoActivity = [[DCKakaoActivity alloc] init];
    DCLineActivity *lineActivity = [[DCLineActivity alloc] init];
    
    NSArray *activities = [[NSArray alloc] initWithObjects:kakaoActivity, lineActivity, nil];
    
    NSLog(@"%@", body);
    // UIActivityViewController
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activities];
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:activityView animated:YES completion:nil];
    NSLog(@"%@", body);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", [request URL]);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@", [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([scrollView isEqual:self.JobWebView.scrollView]) {
        float contentHeight = scrollView.contentSize.height;
        float height = scrollView.frame.size.height;
        float offset = scrollView.contentOffset.y;
        
        if(offset == 0) {
            webViewScrolledToTop = true;
            webViewScrolledToBottom = false;
        } else if(height + offset == contentHeight) {
            webViewScrolledToTop = false;
            webViewScrolledToBottom = true;
        } else {
            webViewScrolledToTop = false;
            webViewScrolledToBottom = false;
        }
        
        //NSLog(@"Webview is at top: %i or at bottom: %i", webViewScrolledToTop, webViewScrolledToBottom);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//647b750fd2fe1f8acde0e91ebaaae00e


#pragma mark NMapViewDelegate Method

- (void) onMapView:(NMapView *)mapView initHandler:(NMapError *)error {
	
	if (error == nil) { // success
		// set map center and level
        //		[_mapView setMapCenter:NGeoPointMake(126.978371, 37.5666091) atLevel:11];
		
	} else { // fail
		NSLog(@"onMapView:initHandler: %@", [error description]);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:[error description]
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
	}
}

- (void) onMapView:(NMapView *)mapView networkActivityIndicatorVisible:(BOOL)visible {
	//NSLog(@"onMapView:networkActivityIndicatorVisible: %d", visible);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
}

- (void) onMapView:(NMapView *)mapView didChangeMapLevel:(int)level {
	NSLog(@"onMapView:didChangeMapLevel: %d", level);
}

- (void) onMapView:(NMapView *)mapView didChangeViewStatus:(NMapViewStatus)status {
	//NSLog(@"onMapView:didChangeViewStatus: %d", status);
}

- (void) onMapView:(NMapView *)mapView didChangeMapCenter:(NGeoPoint)location {
	NSLog(@"onMapView:didChangeMapCenter: (%f, %f)", location.longitude, location.latitude);
}

- (void) onMapView:(NMapView *)mapView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noMove" object:nil];
    }
}
- (void) onMapView:(NMapView *)mapView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
}
- (void) onMapView:(NMapView *)mapView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onMove" object:nil];
    }
}

- (void) onMapView:(NMapView *)mapView handleLongPressGesture:(UIGestureRecognizer*)recogniser {
    
}
- (void) onMapView:(NMapView *)mapView handleSingleTapGesture:(UIGestureRecognizer*)recogniser {
    
    [_toolbar setHidden:![_toolbar isHidden]];
    
    //	[self setLogoImageOffset];
    
	//    [self setMapViewVisibleBounds];
}

- (BOOL) onMapViewIsGPSTracking:(NMapView *)mapView {
	return [[NMapLocationManager getSharedInstance] isTrackingEnabled];
}

#pragma mark NMapPOIdataOverlayDelegate

//
// DEPRECATED, use onMapOverlay:imageForOverlayItem:selected for efficiency
//
//- (UIImage *) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageWithType:(int)poiFlagType iconIndex:(int)index selectedImage:(UIImage **)selectedImage {
//    return nil;
////	return [NMapViewResource imageWithType:poiFlagType iconIndex:index selectedImage:selectedImage];
//}
//
- (UIImage *) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageForOverlayItem:(NMapPOIitem *)poiItem selected:(BOOL)selected {
    
    return [NMapViewResource imageForOverlayItem:poiItem selected:selected constraintSize:_mapView.viewBounds.size];
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay anchorPointWithType:(NMapPOIflagType)poiFlagType {
	return [NMapViewResource anchorPointWithType:poiFlagType];
}

- (UIView*) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay viewForCalloutOverlayItem:(NMapPOIitem *)poiItem
         calloutPosition:(CGPoint *)calloutPosition {
    
    // [TEST] nil을 리턴하면 onMapOverlay:imageForCalloutOverlayItem:... 이 다시 호출됨
    if ([poiItem.title length] > 10) {
        return nil;
    }
    
    CGSize constraintSize = _mapView.bounds.size;
    CGRect calloutHitRect;
	UIImage *image = [NMapViewResource imageForCalloutOverlayItem:poiItem constraintSize:constraintSize selected:NO
                                    imageForCalloutRightAccessory:nil
                                                  calloutPosition:calloutPosition calloutHitRect:&calloutHitRect];
    
    if ([poiItem.title length] > 5) {
        // [TEST] userInteractionEnabled 값이 YES인 UIView를 리턴하면 터치 이벤트를 직접 처리해야함
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        return button;
    }
    
    // [TEST] userInteractionEnabled 값이 NO인 UIView를 리턴하면 선택시 onMapOverlay:imageForCalloutOverlayItem:...이 호출됨
    UIImageView *calloutView = [[UIImageView alloc] initWithImage:image];
    return calloutView;
}

- (UIImage*) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageForCalloutOverlayItem:(NMapPOIitem *)poiItem
		   constraintSize:(CGSize)constraintSize selected:(BOOL)selected
imageForCalloutRightAccessory:(UIImage *)imageForCalloutRightAccessory
          calloutPosition:(CGPoint *)calloutPosition calloutHitRect:(CGRect *)calloutHitRect {
    
	// handle overlapped items
	if (!selected) {
		// check if it is selected by touch event
		if (!poiDataOverlay.focusedBySelectItem) {
			int countOfOverlappedItems = 1;
			
			NSArray *poiData = [poiDataOverlay poiData];
			
			for (NMapPOIitem *item in poiData) {
				// skip selected item
				if (item == poiItem) {
					continue;
				}
				
				// check if overlapped or not
				if (CGRectIntersectsRect([item frame], [poiItem frame])) {
					countOfOverlappedItems++;
				}
			}
			
			if (countOfOverlappedItems > 1) {
				// handle overlapped items
				NSString *strText = [NSString stringWithFormat:@"%d overlapped items for %@", countOfOverlappedItems, poiItem.title];
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:strText
															   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];
				
				// do not show callout overlay
				return nil;
			}
		}
	}
	
	return [NMapViewResource imageForCalloutOverlayItem:poiItem constraintSize:constraintSize selected:selected
						  imageForCalloutRightAccessory:imageForCalloutRightAccessory
										calloutPosition:calloutPosition calloutHitRect:calloutHitRect];
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay calloutOffsetWithType:(NMapPOIflagType)poiFlagType {
	return [NMapViewResource calloutOffsetWithType:poiFlagType];
}

- (void) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay willShowCalloutOverlayItem:(NMapPOIitem *)poiItem {
    NSLog(@"onMapOverlay:willShowCalloutOverlayItem: %@", poiItem);
}

- (BOOL) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didChangeSelectedPOIitemAtIndex:(int)index withObject:(id)object {
	NSLog(@"onMapOverlay:didChangeSelectedPOIitemAtIndex: %d", index);
	
	return YES;
}

- (BOOL) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didDeselectPOIitemAtIndex:(int)index withObject:(id)object {
	NSLog(@"onMapOverlay:didDeselectPOIitemAtIndex: %d", index);
	
	return YES;
}

- (BOOL) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didSelectCalloutOfPOIitemAtIndex:(int)index withObject:(id)object {
	NSLog(@"onMapOverlay:didSelectCalloutOfPOIitemAtIndex: %d", index);
	
	NMapPOIitem *poiItem = [[poiDataOverlay poiData] objectAtIndex:index];
	
	if (poiItem.title) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:poiItem.title
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
	}
	
	return YES;
}

- (void) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didChangePOIitemLocationTo:(NGeoPoint)location withType:(NMapPOIflagType)poiFlagType {
	NSLog(@"onMapOverlay:didChangePOIitemLocationTo: (%f, %f)", location.longitude, location.latitude);
	
	[_mapView findPlacemarkAtLocation:location];
}

#pragma mark MMapReverseGeocoderDelegate

- (void) location:(NGeoPoint)location didFindPlacemark:(NMapPlacemark *)placemark
{
	NSLog(@"location:(%f, %f) didFindPlacemark: %@", location.longitude, location.latitude, [placemark address]);
	
	if (_mapPOIdataOverlay) {
		NMapPOIitem *poiItem = [[_mapPOIdataOverlay poiData] objectAtIndex:0];
		
		if (NGeoPointIsEquals([poiItem location], location)) {
			[poiItem setTitle:[placemark address]];
			
			[_mapPOIdataOverlay selectPOIitemAtIndex:0 moveToCenter:NO];
		}
	}
}
- (void) location:(NGeoPoint)location didFailWithError:(NMapError *)error
{
	NSLog(@"location:(%f, %f) didFailWithError: %@", location.longitude, location.latitude, [error description]);
}

#pragma mark NMapLocationManagerDelegate

- (void)locationManager:(NMapLocationManager *)locationManager didUpdateToLocation:(CLLocation *)location {
	
	CLLocationCoordinate2D coordinate = [location coordinate];
	
	myLocation.longitude = coordinate.longitude;
	myLocation.latitude = coordinate.latitude;
	float locationAccuracy = [location horizontalAccuracy];
	NSLog(@"%f", myLocation.longitude);
	NSLog(@"%f", myLocation.latitude);
	[[_mapView mapOverlayManager] setMyLocation:myLocation locationAccuracy:locationAccuracy];
	
    //	[_mapView setMapCenter:myLocation];
}

- (void)locationManager:(NMapLocationManager *)locationManager didFailWithError:(NMapLocationManagerErrorType)errorType {
	NSString *message = nil;
	
	switch (errorType) {
		case NMapLocationManagerErrorTypeUnknown:
		case NMapLocationManagerErrorTypeCanceled:
		case NMapLocationManagerErrorTypeTimeout:
			message = @"일시적으로 내위치를 확인할 수 없습니다.";
			break;
		case NMapLocationManagerErrorTypeDenied:
			if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0f )
				message = @"위치 정보를 확인할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오.";
			else
				message = @"위치 정보를 확인할 수 없습니다.";
			break;
		case NMapLocationManagerErrorTypeUnavailableArea:
			message = @"현재 위치는 지도내에 표시할 수 없습니다.";
			break;
		case NMapLocationManagerErrorTypeHeading:
			//			[self setCompassHeadingValue:kMapInvalidCompassValue];
			break;
		default:
			break;
	}
	
	if (message) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:message
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
	}
	
	if ([_mapView isAutoRotateEnabled]) {
		//		[self setCompassHeadingValue:kMapInvalidCompassValue];
	}
	
	[[_mapView mapOverlayManager] clearMyLocationOverlay];
}

- (void)locationManager:(NMapLocationManager *)locationManager didUpdateHeading:(CLHeading *)heading {
    
	double headingValue = [heading trueHeading] < 0.0 ? [heading magneticHeading] : [heading trueHeading];
	//	[self setCompassHeadingValue:headingValue];
}



@end
