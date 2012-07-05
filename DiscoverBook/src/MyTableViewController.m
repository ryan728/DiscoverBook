#import "MyTableViewController.h"
#import "DoubanEntrySubject.h"
#import "User.h"
#import "DOUService.h"

@implementation MyTableViewController {
  NSUInteger currentIndex_;
  BOOL hasMore_;
}

#pragma mark - Properties
@synthesize myEntries = myEntries_;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.clearsSelectionOnViewWillAppear = NO;
    myEntries_ = [[NSMutableArray alloc] init];
    currentIndex_ = 0;
    hasMore_ = YES;

    if ([User defaultUser]) {
      [self loadListFrom:0];
    } else {
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultUserFetched:) name:@"UserInfoFetched" object:nil];
    }
  }
  return self;
}

- (void)defaultUserFetched:(NSNotification *)notification {
  [self loadListFrom:0];
}

- (void)loadListFrom:(int)startIndex {
  DOUQuery *query = [self createQuery:startIndex];
  DOUService *service = [DOUService sharedInstance];
  DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {
    if (!request.error) {
      NSArray *const result = [self parseResult:request];
      [myEntries_ addObjectsFromArray:result];

      if (result.count != RESULT_BATCH_SIZE) {
        hasMore_ = NO;
      }

//      [self.tableView reloadRowsAtIndexPaths:<#(NSArray *)indexPaths#> withRowAnimation:<#(UITableViewRowAnimation)animation#>]
      [self.tableView reloadData];
    } else {
      NSLog(@"request.error.description = %@", request.error.description);
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

@end
