#import <Foundation/Foundation.h>
#import "SearchHandler.h"

@class DOUQuery;
@class DOUHttpRequest;

extern UIImage *DEFAULT_CONTACT_ICON;
extern UIImage *DEFAULT_BOOK_COVER_IMAGE;

@interface MyTableViewController : UITableViewController <SearchHandlerDelegate>

@property(nonatomic, strong) NSMutableArray *myEntries;
@property(nonatomic, strong) NSString *userTitle;
@property (nonatomic, strong) SearchHandler *searchHandler;

-(void)loadData;

@end