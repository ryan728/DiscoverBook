#import <QuartzCore/QuartzCore.h>
#import "SearchController.h"
#import "SearchView.h"
#import "SearchResultLabel.h"

static short const MAX_WIDTH = 2560;
static short const MAX_HEIGHT = 1920;
static short const RADIUS = 150;

@implementation SearchController {
  SearchView *background_;
}
@synthesize term = term_;
@synthesize scrollView = scrollView_;
//@synthesize background = background_;

#pragma mark - life cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  scrollView_.minimumZoomScale = 0.4;
  scrollView_.maximumZoomScale = 2;
  scrollView_.delegate = self;
  scrollView_.contentSize = CGSizeMake(MAX_WIDTH, MAX_HEIGHT);
  scrollView_.backgroundColor = [UIColor yellowColor];
  background_ = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT)];
  background_.backgroundColor = [UIColor clearColor];
  [scrollView_ addSubview:background_];

  CGRect bounds = [[UIScreen mainScreen] bounds];

  CGFloat height = bounds.size.height;
  CGFloat width = bounds.size.width;

  CGFloat centerX = MAX_WIDTH / 2;
  CGFloat centerY = MAX_HEIGHT / 2;

  SearchResultLabel *termLabel = [[SearchResultLabel alloc] initWithText:term_ andCenter:CGPointMake(centerX, centerY)];
  termLabel.matcher = -1;
  termLabel.textColor = [UIColor greenColor];
  termLabel.scrollView = scrollView_;
  [background_ addSubview:termLabel];

  int resultCount = 7;
  for (int i = 0; i < resultCount; i++) {
    const double angle = M_PI * 2 / resultCount * i;
    CGFloat anotherCenterX = centerX + sin(angle) * RADIUS;
    CGFloat anotherCenterY = centerY - cos(angle) * RADIUS;
    SearchResultLabel *anotherLabel = [[SearchResultLabel alloc] initWithText:[NSString stringWithFormat:@"result %li", i] andCenter:CGPointMake(centerX, centerY)];
    anotherLabel.matcher = 1;
    anotherLabel.scrollView = scrollView_;
    [background_ addSubview:anotherLabel];
  }

  [background_ scatter];

  [scrollView_ scrollRectToVisible:CGRectMake(centerX - width / 2, centerY - height / 2, width, height) animated:YES];
}



#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return background_;
}

@end