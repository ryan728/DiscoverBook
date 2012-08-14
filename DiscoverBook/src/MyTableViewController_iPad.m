#import "MyTableViewController_iPad.h"
#import "TWImageView+Additions.h"
#import "Book.h"

@interface MyTableViewController_iPad ()

@end

@implementation MyTableViewController_iPad

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
  [parent.view addSubview: self.view];
  CGRect newFrame = CGRectMake(26, 18, 716, 717);
  self.view.frame = newFrame;
  self.view.backgroundColor = [UIColor clearColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath {
  Book *book = [self.searchHandler entryAtIndex:indexPath.row];
  cell.textLabel.text = book.title;
  cell.detailTextLabel.text = book.authorsString;
  [cell.imageView setImageWithAnimation:book.imageUrl andPlaceHolder:DEFAULT_BOOK_COVER_IMAGE];
}

@end
