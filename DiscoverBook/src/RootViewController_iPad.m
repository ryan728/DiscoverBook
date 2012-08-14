#import "RootViewController_iPad.h"
#import "GlobalConfig.h"
#import "WheelViewCell.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "NSArray+Additions.h"
#import "TWImageView+Additions.h"
#import "DoubanService.h"
#import "Book.h"

@interface RootViewController_iPad ()

@property(nonatomic, strong) NSMutableArray *cells;

@end

@implementation RootViewController_iPad

@synthesize cells = _cells;
@synthesize wheelView = _wheelView;

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
  DoubanService * service = [[DoubanService alloc] init];
  [service fetchRandomBooksWithCallBack:^(NSArray *result, DOUHttpRequest *request) {
      [result eachWithIndex:^(Book *book, NSUInteger i) {
        UIImageView *imageView = ((WheelViewCell *)[self.cells objectAtIndex:i]).imageView;
        [imageView setImageWithAnimation:book.imageUrl andPlaceHolder:nil];
      }];
    
    if (request.error) {
      NSLog(@"request.error.description = %@", request.error.description);
      if (![Reachability reachabilityForInternetConnection].isReachable) {
        [self.view makeNetworkToast];
      }
    }
  }];
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
