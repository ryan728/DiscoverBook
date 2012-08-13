#import "MyTableViewController_iphone.h"
#import "DOUAPIEngine.h"

@implementation MyTableViewController_iphone {
  BOOL reloading_;
  EGORefreshTableHeaderView *refreshHeaderView_;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (refreshHeaderView_ == nil) {
    const CGRect frame = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height);
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:frame];
    view.delegate = self;
    [self.tableView addSubview:view];
    refreshHeaderView_ = view;
  }

  [refreshHeaderView_ refreshLastUpdatedDate];
}

- (void)handleResultFor:(DOUHttpRequest *)request {
  [self doneLoadingTableViewData];
  [super handleResultFor:request];
}

#pragma mark Data Source Loading / Reloading Methods

- (void)doneLoadingTableViewData {
  reloading_ = NO;
  [refreshHeaderView_ egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [refreshHeaderView_ egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [refreshHeaderView_ egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
  reloading_ = YES;
  [self loadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
  return reloading_;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
  return [NSDate date];
}
@end
