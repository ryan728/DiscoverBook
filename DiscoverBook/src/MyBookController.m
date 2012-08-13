#import "DOUAPIEngine.h"
#import "DoubanFeedSubject.h"
#import "NSArray+Additions.h"
#import "MyBookController.h"
#import "TWImageView+Additions.h"
#import "BookDetailsController.h"
#import "BookSearchHandler.h"

@implementation MyBookController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.searchHandler = [[BookSearchHandler alloc]init];
  }
  return self;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [super prepareForSegue:segue sender:sender];

  BookDetailsController *const bookDetailsController = segue.destinationViewController;
  DoubanEntrySubject *currentBook = [self.myEntries objectAtIndex:self.tableView.indexPathForSelectedRow.row];
  bookDetailsController.bookDetailsUrl = currentBook.identifier;
  NSString *collectionLink = [[currentBook linkWithRelAttributeValue:@"collection"] href];
  [bookDetailsController setBookCollectionUrl:collectionLink];
}
@end