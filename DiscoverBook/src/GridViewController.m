#import "GridViewController.h"
#import "GridCell.h"
#import "Book.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "DOUService.h"

@implementation GridViewController

@synthesize searchHandler = _searchHandler;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
      _gridView = [[AQGridView alloc] init];
      _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
      _gridView.backgroundColor = [UIColor clearColor];
      _gridView.opaque = NO;
      _gridView.dataSource = self;
      _gridView.delegate = self;
      _gridView.scrollEnabled = NO;
      
      if ( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) )
      {
        // bring 1024 in to 1020 to make a width divisible by five
        _gridView.leftContentInset = 2.0;
        _gridView.rightContentInset = 2.0;
      }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
                                 duration: (NSTimeInterval) duration
{
  if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
    _gridView.leftContentInset = 0.0;
    _gridView.rightContentInset = 0.0;
  } else {
    _gridView.leftContentInset = 2.0;
    _gridView.rightContentInset = 2.0;
  }
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
  [parent.view addSubview: self.gridView];
  CGRect newFrame = CGRectMake(26, 18, 716, 717);
  self.gridView.frame = newFrame;
  [self.gridView reloadData];
}


#pragma - AQGridViewDelegate

#pragma - AQGridViewDataSource

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
  return [_searchHandler cellCount];
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
  static NSString * CellIdentifier = @"CellIdentifier";
  
  GridCell *cell = (GridCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
  if ( cell == nil ) {
    cell = [[GridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 102.0, 152.0) reuseIdentifier: CellIdentifier];
  }
  Book *book = [_searchHandler entryAtIndex:index];
  cell.imageUrl = book.imageUrl;
  cell.title = book.title;
  
  return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView {
  return ( CGSizeMake(192.0, 192.0) );
}

#pragma - SearchHandlerDelegate

- (void)handleResultFor:(DOUHttpRequest *)request {
  if (!request.error) {
    [_gridView reloadData];
  } else {
    NSLog(@"request.error.description = %@", request.error.description);
    if (![Reachability reachabilityForInternetConnection].isReachable) {
      [self.view makeNetworkToast];
    }
  }
}


@end
