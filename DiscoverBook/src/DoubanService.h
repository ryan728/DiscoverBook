#import "DOUService.h"

@interface DoubanService : NSObject

- (void)fetchUserInfo;

- (void)fetchRandomBooksWithCallBack:(void (^)(NSArray* result, DOUHttpRequest *request))callback;

@end
