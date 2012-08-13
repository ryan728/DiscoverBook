#import "MyItemViewController_iPad.h"

@interface MyItemViewController_iPad ()

@end

@implementation MyItemViewController_iPad

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)loadData {
  
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
  [parent.view addSubview: self.view];
  CGRect newFrame = CGRectMake(26, 18, 716, 717);
  self.view.frame = newFrame;
  self.view.backgroundColor = [UIColor yellowColor];
}
@end
