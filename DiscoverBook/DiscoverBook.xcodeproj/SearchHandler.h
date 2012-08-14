#import <Foundation/Foundation.h>

@class MyTableViewController;
@class DOUQuery;

@protocol SearchHandlerDelegate;
@class DOUHttpRequest;
@class DoubanEntrySubject;

@interface SearchHandler : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *userTitle;

- (void)load;
- (NSUInteger)currentCount;
- (NSUInteger)cellCount;
- (id)entryAtIndex:(NSInteger)index;
- (void)loadMore;
- (void)addDelegate:(id<SearchHandlerDelegate>) delegate;
- (void)removeDelegate:(id<SearchHandlerDelegate>)delegate;

@end

@protocol SearchHandlerDelegate

- (void)handleResultFor:(DOUHttpRequest *)request;

@end