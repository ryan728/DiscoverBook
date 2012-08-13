#import "RootViewController_iPad.h"
#import "GlobalConfig.h"
#import "WheelViewCell.h"
#import "DOUService.h"
#import "DOUQuery.h"
#import "DoubanFeedSubject.h"
#import "Macros.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "NSArray+Additions.h"
#import "TWImageView+Additions.h"
#import "DoubanAuthorizationViewController.h"
#import "MainViewController_iPad.h"

@interface RootViewController_iPad ()

@property(nonatomic, strong) NSMutableArray *cells;

@end

@implementation RootViewController_iPad

@synthesize cells = _cells;
@synthesize wheelView = _wheelView;

static NSArray *kBookTags = nil;

+(void) initialize{
  NSError *error = nil;
  NSString *filePath =[[NSBundle mainBundle] pathForResource:@"tags" ofType:@"txt"];
  kBookTags = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    self.cells = [NSMutableArray arrayWithCapacity:kCellCount];
    UIImage *defaultImage = [UIImage imageNamed:@"default_book_cover.jpg"];
    for (NSUInteger index = 0; index < kCellCount; index++) {
      WheelViewCell *cell = [[WheelViewCell alloc] initWithImage:defaultImage];
      [self.cells addObject:cell];
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self fetchBooks];
}

- (void)fetchBooks {
  NSInteger tagIndex = arc4random() % kBookTags.count;
  NSInteger startIndex = arc4random() % 10;
  
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array([kBookTags objectAtIndex:tagIndex], [NSString stringWithFormat:@"%d", kCellCount], [NSString stringWithFormat:@"%d", startIndex]) forKeys:Array(@"tag", @"max-results", @"start-index")];
  DOUQuery *query = [[DOUQuery alloc] initWithSubPath:@"/book/subjects" parameters:parameters];
  DOUService *service = [DOUService sharedInstance];
  DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {
    if (!request.error) {
      DoubanFeedSubject *const feedSubject = [[DoubanFeedSubject alloc] initWithData:request.responseData];
      NSArray *const entries = feedSubject.entries;
      [entries eachWithIndex:^(DoubanEntrySubject *item, NSUInteger i) {
        UIImageView *imageView = ((WheelViewCell *)[self.cells objectAtIndex:i]).imageView;
        [imageView setImageWithAnimation:[[item linkWithRelAttributeValue:@"image"] URL] andPlaceHolder:nil];
      }];
    } else {
      NSLog(@"request.error.description = %@", request.error.description);
      if (![Reachability reachabilityForInternetConnection].isReachable) {
        [self.view makeNetworkToast];
      }
    }
  };
  [service get:query callback:completionBlock];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
    self.wheelView.style = WheelViewStyleCarousel;
  } else {
    self.wheelView.style = WheelViewStyleWheel;
  }
}

- (void)handleShowUserInfoSegue:(UIStoryboardSegue *)segue {
  
}

#pragma - WheelViewDataSource

-(NSInteger)wheelViewNumberOfCells:(WheelView *)wheelView {
  return kCellCount;
}

-(WheelViewCell *)wheelView:(WheelView *)wheelView cellAtIndex:(NSInteger)index {
  return [self.cells objectAtIndex:index];
}


@end
