//
//  NMapPathDataOverlay.h
//  NaverMap
//
//  Created by KJ KIM on 10. 10. 20..
//  Copyright 2010 NHN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "NMapOverlay.h"

#import "NMapPathData.h"
#import "NMapCircleData.h"

@class NMapOverlayManager;
@class NMapPathDataRenderer;
@class NMapCircleDataRenderer;

// FIXME: interface
@interface NMapPathDataOverlay : NMapOverlay {

	NMapView *_mapView;
	NMapOverlayManager *_mapOverlayManager;
	NGRect _viewPortOrigin;
    int _zoomLevel;

	NSMutableArray *_pathDataArray; // array of NMapPathData
    NMapPathLineStyle *_pathLineStyle;
    NMapPathDataRenderer *_pathDataRenderer;
    
    NSMutableArray *_circleDataArray; // array of NMapCircleData
    NMapCircleStyle *_circleStyle;
    NMapCircleDataRenderer *_circleDataRenderer;
}

@property (nonatomic, assign) NMapView *mapView;
@property (nonatomic, assign) NMapOverlayManager *mapOverlayManager;


- (id)init;
- (id)initWithPathData:(NMapPathData *)pathData;
- (id)initWithPathDataArray:(NSArray *)pathDataArray;

// set line width in points to the default line style.
- (void) setLineWidth:(float)width;

// set line color to the default line style.
- (void) setLineColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

/**
 * Add a new instance of NMapPathData on this overlay.
 * If pathData does not have path line style, default style is used.
 * 
 * @param pathData pathData is to be drawn on this overlay
 */
- (void) addPathData:(NMapPathData *)pathData;

/**
 * Add a new instance of NMapCircleData on this overlay.
 * If circleData does not have circle style, default style is used.
 * 
 * @param circleData circleData is to be drawn on this overlay
 */
- (void) addCircleData:(NMapCircleData *)circleData;

/**
 *  Show all path data.
 *
 *  @param zoomLevel 0 to show all path data in the NMapView, otherwise it is centered with the given zoom level.
 */
- (void) showAllPathDataAtLevel:(int)zoomLevel;
- (void) showAllPathData;

// check if bounds of path data contains a location
- (BOOL) containsLocation:(NGeoPoint)location;

@end
