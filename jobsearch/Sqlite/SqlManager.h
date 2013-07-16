//
//  SqlManager.h
//  SmartLife
//
//  Created by Ray on 11. 1. 28..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef enum
{
	FROM_ALLBEST,
	FROM_ALLEVENT,
	FROM_ALLMEMBERSHIP,
	FROM_ALLCMS,
	FROM_MYCOUPON,
	FROM_MYCMS,
	FROM_MYGIFT,
} FROM_WHAT;

NSMutableArray * getList(NSString *name);

NSString* getDbPath(void);

NSString * clearNull(NSString* tmp);
