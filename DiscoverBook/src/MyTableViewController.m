#import "MyTableViewController.h"
#import "DoubanEntrySubject.h"
#import "User.h"
#import "DOUService.h"
#import "Reachability.h"
#import "Toast+UIView.h"

@implementation MyTableViewController {
  NSUInteger currentIndex_;
  BOOL hasMore_;
  BOOL reloading_;
  EGORefreshTableHeaderView *refreshHeaderView_;
}

#pragma mark - Properties
@synthesize myEntries = myEntries_;
@synthesize userTitle = userTitle_;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.clearsSelectionOnViewWillAppear = NO;
    myEntries_ = [[NSMutableArray alloc] init];
    currentIndex_ = 0;
    hasMore_ = YES;
  }
  return self;
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


- (void)loadData {
  User *const user = [User findUserWithTitle:userTitle_];
  if (user) {
    [self loadListFrom:0];
    userTitle_ = user.title;
  } else {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultUserFetched:) name:@"UserInfoFetched" object:nil];
  }
}

- (void)defaultUserFetched:(NSNotification *)notification {
  [self loadListFrom:0];
  userTitle_ = [User defaultUser].title;
}

- (void)loadListFrom:(int)startIndex {
  DOUQuery *query = [self createQuery:startIndex];
  DOUService *service = [DOUService sharedInstance];
  DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {
    [self doneLoadingTableViewData];
    if (startIndex == 0) {
      [myEntries_ removeAllObjects];
    }
    if (!request.error) {
      NSArray *const result = [self parseResult:request];
      [myEntries_ addObjectsFromArray:result];
      hasMore_ = (result.count == RESULT_BATCH_SIZE);
      [self.tableView reloadData];
    } else {
      NSLog(@"request.error.description = %@", request.error.description);
      if (![Reachability reachabilityForInternetConnection].isReachable) {
        [self.view makeNetworkToast];
      }
    }
  };
  [service get:query callback:completionBlock];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
  self.tabBarController.navigationItem.title = self.title;
  [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
  if (myEntries_.count == 0) {
    return 0;
  }
  return hasMore_ ? myEntries_.count + 1 : myEntries_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
  NSString *CellIdentifier = @"myBookTableViewCell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  if (indexPath.row == myEntries_.count) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.textLabel.text = @"Load more ...";
  } else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self renderCell:cell at:indexPath];
  }

  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == myEntries_.count) {
    [self loadListFrom:myEntries_.count + 1];
  }
}

#pragma mark - SearchHandler

- (void)throwImplementationException {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
          userInfo:nil];
}

- (NSArray *)parseResult:(DOUHttpRequest *)request {
  [self throwImplementationException];
  return nil;
}

- (DOUQuery *)createQuery:(int)startIndex {
  [self throwImplementationException];
  return nil;
}

- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath {
  [self throwImplementationException];
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
