#import "MyTableViewController_ResponseHandler.h"
#import "DoubanEntrySubject.h"
#import "User.h"
#import "DOUService.h"
#import "Reachability.h"
#import "Toast+UIView.h"

@implementation MyTableViewController {
}

UIImage *DEFAULT_CONTACT_ICON = nil;
UIImage *DEFAULT_BOOK_COVER_IMAGE = nil;

+ (void)initialize {
  NSString *defaultContactPath = [[NSBundle mainBundle] pathForResource:@"default_contact" ofType:@"png"];
  NSString *defaultBookCoverPath = [[NSBundle mainBundle] pathForResource:@"default_book_cover" ofType:@"jpg"];
  DEFAULT_BOOK_COVER_IMAGE = [UIImage imageWithContentsOfFile:defaultBookCoverPath];
  DEFAULT_CONTACT_ICON = [UIImage imageWithContentsOfFile:defaultContactPath];
}

#pragma mark - Properties
@synthesize searchHandler = _searchHandler;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.clearsSelectionOnViewWillAppear = NO;
  }
  return self;
}

- (void)setSearchHandler:(SearchHandler *)searchHandler {
  searchHandler.title = self.title;
  searchHandler.delegate = self;
  _searchHandler = searchHandler;
}

- (void)loadData {
  [_searchHandler load];
}


- (void)handleResultFor:(DOUHttpRequest *)request {
  NSLog(@"------------------- response : %@", request.responseString);
  if (!request.error) {
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
  return [_searchHandler cellCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
  NSString *CellIdentifier = @"myBookTableViewCell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  if (indexPath.row == [_searchHandler currentCount]) {
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
  if (indexPath.row == [_searchHandler currentCount]) {
    [_searchHandler loadMore];
  }
}


- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
          userInfo:nil];
}

@end