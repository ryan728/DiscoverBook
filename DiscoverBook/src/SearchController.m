#import "SearchController.h"


@implementation SearchController {

}
@synthesize term = _term;

#pragma mark - life cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  UILabel *const label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  label.text = _term;
  [self.view addSubview:label];
}


@end