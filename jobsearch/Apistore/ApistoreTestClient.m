#import "ApistoreTestClient.h"

@implementation DaumSearchTest
@synthesize authenticationHandlers;

NSString *const PUBLIC_DNS = @"http://api.apistore.co.kr/";

- (DaumSearchTest*) initWithKeys:(NSString*)mashapePublicKey mashapePrivateKey:(NSString*)mashapePrivateKey auth:(NSString*)auth {
	authenticationHandlers = [[NSMutableArray alloc]init];
	[authenticationHandlers addObject: [[MashapeAuthentication alloc]initWithMashapeKeys:mashapePublicKey privateKey:mashapePrivateKey]];
	[authenticationHandlers addObject: [[QueryAuthentication alloc]initWithParam:@"auth" value:auth]];

	return self;
}

- (MashapeResponse*) httpApisDaumNetSearch: (NSString*)apikey output:(NSString*)output q:(NSString*)q {

	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
		[parameters setObject:apikey forKey:@"apikey"];[parameters setObject:output forKey:@"output"];[parameters setObject:q forKey:@"q"];

	return [HttpClient doRequest:GET url:[NSString stringWithFormat:@"%@%@", PUBLIC_DNS, [NSString stringWithFormat:@"/web"]] parameters:parameters contentType:C_FORM responseType:R_JSON authenticationHandlers:authenticationHandlers callback:nil];
}

- (void) httpApisDaumNetSearchWithCallback: (NSString*)apikey output:(NSString*)output q:(NSString*)q callback:(id<MashapeDelegate>)callback {

	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
		[parameters setObject:apikey forKey:@"apikey"];[parameters setObject:output forKey:@"output"];[parameters setObject:q forKey:@"q"];

	[HttpClient doRequest:GET url:[NSString stringWithFormat:@"https://%@%@", PUBLIC_DNS, [NSString stringWithFormat:@"/web"]] parameters:parameters contentType:C_FORM responseType:R_JSON authenticationHandlers:authenticationHandlers callback:callback];
}



@end
