#import "MainViewController_iPad.h"
#import "MyBookController.h"

@interface MainViewController_iPad ()

@property MyBookController *tableScene;

@end

@implementation MainViewController_iPad

@synthesize tableScene = _tableScene;

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableScene = [self.storyboard instantiateViewControllerWithIdentifier:@"tableScene"];
  self.tableScene.title = @"reading";
  [self addChildViewController:self.tableScene];
  [self.tableScene loadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void) loadData {
  [self.tableScene loadData];
}


@end
