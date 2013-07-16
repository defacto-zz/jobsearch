#import "Mashape.h"

@interface DaumSearchTest : NSObject {
	NSMutableArray* authenticationHandlers;
}
@property(nonatomic, retain) NSMutableArray* authenticationHandlers;

- (DaumSearchTest*) initWithKeys: (NSString*)mashapePublicKey mashapePrivateKey:(NSString*)mashapePrivateKey auth:(NSString*)auth;
- (MashapeResponse*) httpApisDaumNetSearch: (NSString*)apikey output:(NSString*)output q:(NSString*)q;
- (void) httpApisDaumNetSearchWithCallback: (NSString*)apikey output:(NSString*)output q:(NSString*)q callback:(id<MashapeDelegate>)callback;


@end

