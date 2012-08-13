#import <Foundation/Foundation.h>

@class MyTableViewController;
@class DOUQuery;

@protocol SearchHandlerDelegate;
@class DOUHttpRequest;
@class DoubanEntrySubject;

@interface SearchHandler : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *userTitle;
@property (strong, nonatomic) id<SearchHandlerDelegate> delegate;

- (void)load;
- (NSUInteger)currentCount;
- (NSUInteger)cellCount;
- (id)entryAtIndex:(NSInteger)index;

- (void)loadMore;
@end

@protocol SearchHandlerDelegate

- (void)handleResultFor:(DOUHttpRequest *)request;

@end