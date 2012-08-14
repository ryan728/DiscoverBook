#import "DOUAPIEngine.h"
#import "DoubanFeedSubject.h"
#import "MyBookController.h"
#import "TWImageView+Additions.h"
#import "BookDetailsController.h"
#import "BookSearchHandler.h"
#import "Book.h"

@implementation MyBookController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.searchHandler = [[BookSearchHandler alloc]init];
  }
  return self;
}

- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath {
  Book *book = [self.searchHandler entryAtIndex:indexPath.row];
  cell.textLabel.text = book.title;
  cell.detailTextLabel.text = book.authorsString;
  [cell.imageView setImageWithAnimation:book.imageUrl andPlaceHolder:DEFAULT_BOOK_COVER_IMAGE];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [super prepareForSegue:segue sender:sender];

  BookDetailsController *const bookDetailsController = segue.destinationViewController;
  DoubanEntrySubject *currentBook = [self.searchHandler entryAtIndex:self.tableView.indexPathForSelectedRow.row];
  bookDetailsController.bookDetailsUrl = currentBook.identifier;
  NSString *collectionLink = [[currentBook linkWithRelAttributeValue:@"collection"] href];
  [bookDetailsController setBookCollectionUrl:collectionLink];
}
@end