#import <UIKit/UIKit.h>

@class DOUQuery;
@class DOUHttpRequest;

static NSUInteger const RESULT_BATCH_SIZE = 10;

@protocol SearchHandler <NSObject>

@required
- (DOUQuery *)createQuery:(int)startIndex;
- (NSArray *)parseResult:(DOUHttpRequest *)request;
- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath;

@end

@interface MyTableViewController : UITableViewController <SearchHandler>

@property(nonatomic, strong) NSMutableArray *myEntries;

@end
