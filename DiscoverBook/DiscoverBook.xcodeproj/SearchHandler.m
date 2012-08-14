#import "SearchHandler_protected.h"
#import "DOUQuery.h"
#import "DOUAPIEngine.h"
#import "GlobalConfig.h"
#import "User.h"
#import "NSArray+Additions.h"

@implementation SearchHandler {
  NSMutableArray *_myEntries;
  BOOL _hasMore;
  NSMutableArray *_delegates;
}

@synthesize userTitle = _userTitle;
@synthesize title = _title;

- (id)init {
  self = [super init];
  if (self) {
    _myEntries = [[NSMutableArray alloc] init];
    _hasMore = YES;
    _delegates = [NSMutableArray array];
  }
  return self;
}

- (void)addDelegate:(id<SearchHandlerDelegate>)delegate{
  [_delegates addObject:delegate];
}

- (void)removeDelegate:(id<SearchHandlerDelegate>)delegate{
  [_delegates removeObject:delegate];
}

- (NSUInteger)currentCount {
  return _myEntries.count;
}

- (NSUInteger)cellCount {
  if (_myEntries.count == 0) {
    return 0;
  }
  return _hasMore ? _myEntries.count + 1 : _myEntries.count;
}

- (id)entryAtIndex:(NSInteger)index {
  return [_myEntries objectAtIndex:index];
}

- (void)load {
  User *const user = [User findUserWithTitle:_userTitle];
  if (user) {
    _userTitle = user.title;
    [self loadFrom:0];
  } else {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultUserFetched:) name:@"UserInfoFetched" object:nil];
  }
}

- (void)defaultUserFetched:(NSNotification *)notification {
  _userTitle = [User defaultUser].title;
  [self loadFrom:0];
}

- (void)loadFrom:(int)startIndex {
  DOUQuery *query = [self createQuery:startIndex];
  DOUService *service = [DOUService sharedInstance];
  DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {

    if (startIndex == 0) {
      [_myEntries removeAllObjects];
    }

    if (!request.error) {
      NSArray *const result = [self parseResult:request];
      _hasMore = (result.count == kBatchSize);
      [_myEntries addObjectsFromArray:result];

      [_delegates each:^(id<SearchHandlerDelegate> delegate) {
        [delegate handleResultFor:request];
      }];
    }
  };
  [service get:query callback:completionBlock];
}

- (void)loadMore {
  [self loadFrom:_myEntries.count + 1];
}
@end