#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class DOUQuery;
@class DOUHttpRequest;

static NSUInteger const RESULT_BATCH_SIZE = 10;

@protocol SearchHandler <NSObject>

@required
- (DOUQuery *)createQuery:(int)startIndex;
- (NSArray *)parseResult:(DOUHttpRequest *)request;
- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath;

@end

@interface MyTableViewController : UITableViewController <SearchHandler, EGORefreshTableHeaderDelegate>

@property(nonatomic, strong) NSMutableArray *myEntries;
@property (nonatomic, strong) NSString *userTitle;

-(void)loadData;

@end
