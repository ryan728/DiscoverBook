#import "MyTableViewController_iPad.h"
#import "DoubanEntrySubject.h"
#import "GDataBaseElements.h"
#import "NSArray+Additions.h"
#import "TWImageView+Additions.h"

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
  DoubanEntrySubject *book = [self.myEntries objectAtIndex:indexPath.row];
  cell.textLabel.text = book.title.stringValue;
  
  NSMutableString *authors = [NSMutableString string];
  [book.authors each:^(GDataAtomAuthor *author) {
    [authors appendString:author.name];
  }];
  cell.detailTextLabel.text = authors;
  
  NSURL *const imageUrl = [[book linkWithRelAttributeValue:@"image"] URL];
  [cell.imageView setImageWithAnimation:imageUrl andPlaceHolder:DEFAULT_BOOK_COVER_IMAGE];
}

@end
