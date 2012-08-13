#import "MainViewController_iPad.h"
#import "MyTableViewController_iPad.h"
#import "BookSearchHandler.h"

@interface MainViewController_iPad ()

@property MyTableViewController_iPad *tableScene;

@end

@implementation MainViewController_iPad

@synthesize tableScene = _tableScene;

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableScene = [self.storyboard instantiateViewControllerWithIdentifier:@"tableScene"];
  self.tableScene.title = @"reading";
  self.tableScene.searchHandler = [[BookSearchHandler alloc] init];
  [self addChildViewController:self.tableScene];
  [self.tableScene didMoveToParentViewController:self];
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
