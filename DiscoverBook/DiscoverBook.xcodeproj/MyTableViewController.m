#import "MyTableViewController_ResponseHandler.h"
#import "DoubanEntrySubject.h"
#import "User.h"
#import "DOUService.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "GlobalConfig.h"

@implementation MyTableViewController {
  NSUInteger _currentIndex;
  BOOL _hasMore;
}

UIImage *DEFAULT_CONTACT_ICON = nil;
UIImage *DEFAULT_BOOK_COVER_IMAGE = nil;

+ (void)initialize {
  NSString *defaultBookCoverPath = [[NSBundle mainBundle] pathForResource:@"default_contact" ofType:@"png"];
  NSString *defaultContactPath = [[NSBundle mainBundle] pathForResource:@"default_book_cover" ofType:@"jpg"];
  DEFAULT_BOOK_COVER_IMAGE = [UIImage imageWithContentsOfFile:defaultBookCoverPath];
  DEFAULT_CONTACT_ICON = [UIImage imageWithContentsOfFile:defaultContactPath];
}

#pragma mark - Properties
@synthesize myEntries = _myEntries;
@synthesize userTitle = _userTitle;
@synthesize searchHandler = _searchHandler;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.clearsSelectionOnViewWillAppear = NO;
    _myEntries = [[NSMutableArray alloc] init];
    _currentIndex = 0;
    _hasMore = YES;
  }
  return self;
}

- (void)setSearchHandler:(SearchHandler *)searchHandler {
  searchHandler.title = self.title;
  searchHandler.userTitle = self.userTitle;
  searchHandler.delegate = self;
  _searchHandler = searchHandler;
}

- (void)loadData {
  User *const user = [User findUserWithTitle:_userTitle];
  if (user) {
    _userTitle = user.title;
    _searchHandler.userTitle = _userTitle;
    [_searchHandler loadListFrom:0];
  } else {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultUserFetched:) name:@"UserInfoFetched" object:nil];
  }
}

- (void)defaultUserFetched:(NSNotification *)notification {
  [_searchHandler loadListFrom:0];
  _userTitle = [User defaultUser].title;
  _searchHandler.userTitle = _userTitle;
}

- (void)handleResult:(NSArray *)result startFrom:(NSInteger)startIndex withRequest:(DOUHttpRequest *)request {
  NSLog(@"------------------- response : %@", request.responseString);
  if (startIndex == 0) {
    [_myEntries removeAllObjects];
  }
  if (!request.error) {
    [_myEntries addObjectsFromArray:result];
    _hasMore = (result.count == kBatchSize);
    [self.tableView reloadData];
  } else {
    NSLog(@"request.error.description = %@", request.error.description);
    if (![Reachability reachabilityForInternetConnection].isReachable) {
      [self.view makeNetworkToast];
    }
  }
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
  if (_myEntries.count == 0) {
    return 0;
  }
  return _hasMore ? _myEntries.count + 1 : _myEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
  NSString *CellIdentifier = @"myBookTableViewCell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  if (indexPath.row == _myEntries.count) {
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
  if (indexPath.row == _myEntries.count) {
    [_searchHandler loadListFrom:_myEntries.count + 1];
  }
}


- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
          userInfo:nil];
}

@end