#import "BookNetController.h"
#import "DoubanEntrySubject.h"
#import "BookView.h"
#import "DOUAPIEngine.h"
#import "Macros.h"
#import "DoubanFeedSubject.h"
#import "NSArray+Additions.h"

@interface BookNetController ()

@property(nonatomic, strong) DoubanEntrySubject *book;
@property(nonatomic, strong) NSMutableArray* bookIds;

@end

@implementation BookNetController

#pragma mark - Properties
@synthesize book = _book;
@synthesize canvas = _canvas;
@synthesize bookView = _bookView;
@synthesize bookIds = _bookIds;

#pragma mark - BookNetController

- (IBAction)back:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle


- (id)initWithBook:(DoubanEntrySubject *)book {
  self = [self init];
  if (self) {
    _book = book;
    _bookIds = [[NSMutableArray alloc] init];
    [_bookIds addObject:_book.identifier];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSBundle mainBundle] loadNibNamed:@"BookNetView" owner:self options:nil];
  _bookView = [[BookView alloc] initWithBook:_book at:_canvas.center];
  [_canvas addSubview:_bookView];

  UILongPressGestureRecognizer *const longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(search)];
  [_bookView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)search {
  [_bookView wobble];

  NSString *const tag = ((DoubanTag *) [[_book tags] objectAtIndex:0]).name;
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array(tag, @"6") forKeys:Array(@"tag", @"max-results")];
  DOUQuery *const query = [[DOUQuery alloc] initWithSubPath:@"/book/subjects" parameters:parameters];
  query.apiBaseUrlString = @"http://api.douban.com";
  DOUHttpRequest *request = [DOUHttpRequest requestWithQuery:query target:self];
  [request setRequestMethod:@"GET"];
  [request startAsynchronous];
}

- (void)requestFinished:(DOUHttpRequest *)request {
  NSLog(@"request.responseString = %@", request.responseString);
  [_bookView clearAnimation];
  DoubanFeedSubject *results = [[DoubanFeedSubject alloc] initWithData:request.responseData];
  [results.entries eachWithIndex:^(DoubanEntrySubject *result, NSUInteger index) {
    if ([_bookIds containsObject:result.identifier]) {
      return;
    }

    [_bookIds addObject:result.identifier];
    BookView *view = [[BookView alloc] initWithBook:result at:CGPointMake(index * 110 + 55, 55)];
    [_canvas addSubview:view];
  }];
}

- (void)requestFailed:(DOUHttpRequest *)request {
  NSLog(@"request.error.description = %@", request.error.description);
}

@end
