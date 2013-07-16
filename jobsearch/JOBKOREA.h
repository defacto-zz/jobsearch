//
//  JOBKOREA.h
//  jobsearch
//
//  Created by CHAN on 13. 6. 1..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	etNone = 0,
	etItem
} eElementType;

@interface JOBKOREA : NSObject  <NSXMLParserDelegate, UIWebViewDelegate>

@property (strong, nonatomic) void(^handlerBlock)(NSArray* items);
@property (strong, nonatomic) void(^GIBBlock)(NSDictionary* items);

@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) NSMutableDictionary* item;
@property (strong, nonatomic) NSMutableString *xmlValue;
@property (strong, nonatomic) NSArray *GI_Part_No;
@property (strong, nonatomic) NSArray *GI_Part_No_major;
@property (strong, nonatomic) NSArray *AREA;
@property (strong, nonatomic) NSArray *SEX;
@property (strong, nonatomic) NSArray *PAY;
@property (strong, nonatomic) NSArray *CTYPE;
@property (strong, nonatomic) NSArray *MCAREERCHK;
@property (strong, nonatomic) NSArray *JTYPE;
@property (strong, nonatomic) NSDictionary *AREACODE;

@property (strong, nonatomic) IBOutlet UIWebView *GIBWebView;
@property (strong, nonatomic) IBOutlet UIWebView *webView1;
@property (strong, nonatomic) IBOutlet UIWebView *webView2;
@property (strong, nonatomic) IBOutlet UIWebView *webView3;
@property (strong, nonatomic) IBOutlet UIWebView *webView4;

@property (strong, nonatomic) NSMutableDictionary* webStr;
@property (strong, nonatomic) void(^GIBWebBlock)(NSDictionary* webStrs);

-(void) jobkoreaRequest:(NSString*)url handler:(void (^)(NSArray*))aHandlerBlock;

-(void) GIBRequest:(NSDictionary*)GIB handler:(void (^)(NSDictionary*))aGIBBlock;

-(void) GIBParse:(NSString*)GIB handler:(void (^)(NSDictionary*))aGIBBlock;

-(void) GIBWebParse:(NSDictionary*)GIB handler:(void (^)(NSDictionary*))GIBWebBlock;

@end
