#import <Foundation/Foundation.h>

@class MyTableViewController;
@class DOUQuery;

@protocol SearchHandlerDelegate;
@class DOUHttpRequest;

@interface SearchHandler : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *userTitle;
@property (strong, nonatomic) id<SearchHandlerDelegate> delegate;

- (void)loadListFrom:(int)startIndex;

@end

@protocol SearchHandlerDelegate

- (void)handleResult:(NSArray *)result startFrom:(NSInteger)startIndex withRequest:(DOUHttpRequest *)request;

@end