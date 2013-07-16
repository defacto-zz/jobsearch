//
//  SqlManager.m
//  PBook
//
//  Created by Ray on 10. 8. 28..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SqlManager.h"
#import "sqlite3.h"

// sqlite cipher 암호
#define KEY "PRAGMA key = \"x'171668FD29C931BC935FB7E6A7F9D2808ADE6B1AA845C4A31A39C12630D40C70'\";"

NSMutableArray * getList(NSString *name) {
	
	sqlite3 *encryptedDb;
	
	if (sqlite3_open([getDbPath() UTF8String], &encryptedDb) != SQLITE_OK) {
		sqlite3_close(encryptedDb);
		NSLog(@"Failed to open database with message '%s'.", sqlite3_errmsg(encryptedDb));
	}
	
	sqlite3_exec(encryptedDb, NULL, NULL, NULL, NULL);
	
	const char *query = [[NSString stringWithFormat:@"SELECT * FROM nice WHERE NAME LIKE '%%%@%%'", name] UTF8String];
	NSLog(@"%s", query);
	sqlite3_stmt *stmt;
	
	NSMutableArray *rtnArray = [[NSMutableArray alloc] init];
	
	if(sqlite3_prepare_v2(encryptedDb, query, -1, &stmt, NULL) == SQLITE_OK) {
//        NSLog(@"%s", [name UTF8String]);
//		sqlite3_bind_text(stmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
		
		while (sqlite3_step(stmt) != SQLITE_DONE) {
			NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)])  forKey:@"KIS"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)])  forKey:@"NAME"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)])  forKey:@"A"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)])  forKey:@"B"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)])  forKey:@"C"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)])  forKey:@"D"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)])  forKey:@"E"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)])  forKey:@"F"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)])  forKey:@"G"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)])  forKey:@"H"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 10)])  forKey:@"I"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 11)])  forKey:@"J"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 12)])  forKey:@"K"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 13)])  forKey:@"L"];
			[tmpDic setObject:clearNull([NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 14)])  forKey:@"M"];
			[rtnArray addObject:tmpDic];
		}
		sqlite3_finalize(stmt);
	} else {
		NSLog(@"Error preparing statement '%s'", sqlite3_errmsg(encryptedDb));
	}
	sqlite3_close(encryptedDb);
	
	return rtnArray;
}

NSString* getDbPath() {
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"nice" ofType:@"sqlite"];
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	if ([fileManager fileExistsAtPath:dbPath] == YES) {
		NSLog(@"DB Path : CREATED");
	} else {
		NSLog(@"DB Path : NOT YET !!");
	}
    //	[fileManager release];
    //	NSLog(@"DB Path : %@", tmpPath);
	return dbPath;
}

NSString * clearNull(NSString* tmp) {
	if ([tmp isKindOfClass:[NSNull class]] || tmp == nil) {
		return @"";
	}
	return [tmp stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
	
}
