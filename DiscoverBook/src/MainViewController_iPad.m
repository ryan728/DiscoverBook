#import "MainViewController_iPad.h"
#import "MyTableViewController_iPad.h"
#import "GridViewController.h"
#import "BookSearchHandler.h"

@implementation MainViewController_iPad {
  MyTableViewController_iPad *_tableScene;
  GridViewController *_gridScene;
}

@synthesize displayTypeControl = _displayTypeControl;

- (void)displayTypeChanged:(id)sender {
  switch ([sender selectedSegmentIndex]) {
    case 0:
      [_gridScene.gridView removeFromSuperview];
      [_tableScene didMoveToParentViewController:self];
      break;
    case 1:
      [_tableScene.view removeFromSuperview];
      [_gridScene didMoveToParentViewController:self];
      break;
    case 2:
      break;
    default:
      break;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  BookSearchHandler *searchHandler = [[BookSearchHandler alloc] init];
  
  _tableScene = [self.storyboard instantiateViewControllerWithIdentifier:@"tableScene"];
  _tableScene.searchHandler = searchHandler;
  [searchHandler addDelegate:_tableScene];
  [self addChildViewController:_tableScene];
  [_tableScene didMoveToParentViewController:self];
  
  _gridScene = [self.storyboard instantiateViewControllerWithIdentifier:@"gridScene"];
  _gridScene.searchHandler = searchHandler;
  [self addChildViewController:_gridScene];
  [searchHandler addDelegate:_gridScene];
  
  searchHandler.title =  @"reading";
  [searchHandler load];

  [_displayTypeControl addTarget:self action:@selector(displayTypeChanged:) forControlEvents:UIControlEventValueChanged];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}


@end
