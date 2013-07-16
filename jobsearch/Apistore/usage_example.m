#import "ApistoreTestClient.h"

@interface sample : NSObject

+ (void) doSomething;

@end

@implementation sample

+ (void) doSomething {

	ApistoreTestClient* client = [[ApistoreTestClient alloc] clientKey:@"CLIENT_KEY"];

    ApistoreResponse* response = [client httpApistoreClient:@"FILL IN PARAMETERS"];

    NSLog(@"The HTTP status code is %d", [response code]);
    NSLog(@"The HTTP headers are %@", [response headers]);
    NSLog(@"The HTTP parsed body is %@", [response body]);
    NSLog(@"The HTTP raw body is %@", [response rawBody]);

}

@end
