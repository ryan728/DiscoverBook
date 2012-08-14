#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "SearchHandler.h"

@interface GridViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate, SearchHandlerDelegate>

@property (nonatomic, strong) SearchHandler *searchHandler;
@property (nonatomic, strong) AQGridView *gridView;

@end
