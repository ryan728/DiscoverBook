#import <QuartzCore/QuartzCore.h>
#import "SearchController.h"

@implementation SearchController {
  UIView *background_;
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
  scrollView_.contentSize = CGSizeMake(2560, 1920);
  background_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2560, 1920)];
  [scrollView_ addSubview:background_];

  CGRect bounds = [[UIScreen mainScreen] bounds]; 

  CGFloat height = bounds.size.height;
  CGFloat width = bounds.size.width;

  UILabel *termLabel = [[UILabel alloc] init];
  termLabel.text = term_;
  termLabel.frame = CGRectMake((2560 - termLabel.frame.size.width) / 2, (1920 - termLabel.frame.size.height) / 2, termLabel.frame.size.width, termLabel.frame.size.height);
  [termLabel sizeToFit];
  NSLog(@"NSStringFromCGRect(termLabel.frame) = %@", NSStringFromCGRect(termLabel.frame));
  [background_ addSubview:termLabel];
  [scrollView_ scrollRectToVisible:CGRectMake((2560 - width) / 2, (1920 - height) / 2, width, height) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return background_;
}

@end