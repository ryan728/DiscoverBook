#import <Foundation/Foundation.h>
#import "SearchHandler.h"

@interface SearchHandler(SearchHandler_protected)

- (NSArray *)parseResult:(DOUHttpRequest *)request;
- (DOUQuery *)createQuery:(int)startIndex;

@end