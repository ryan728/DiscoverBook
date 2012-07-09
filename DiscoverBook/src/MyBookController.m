#import "DOUQuery.h"
#import "DOUAPIEngine.h"
#import "DoubanFeedSubject.h"
#import "NSArray+Additions.h"
#import "Macros.h"
#import "User.h"
#import "MyBookController.h"
#import "TWImageView+Additions.h"
#import "UIImageView+AFNetworking.h"
#import "BookDetailsController.h"

@implementation MyBookController

static UIImage *DEFAULT_BOOK_COVER_IMAGE = nil;

+ (void)initialize {
  NSString *defaultBookCoverPath = [[NSBundle mainBundle] pathForResource:@"default_book_cover" ofType:@"jpg"];
  DEFAULT_BOOK_COVER_IMAGE = [UIImage imageWithContentsOfFile:defaultBookCoverPath];
}

- (DOUQuery *)createQuery:(int)startIndex {
  User *user = [User defaultUser];
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array(@"book", self.title.lowercaseString, [NSString stringWithFormat:@"%u", RESULT_BATCH_SIZE], [NSString stringWithFormat:@"%u", startIndex]) forKeys:Array(@"cat", @"status", @"max-results", @"start-index")];
  return [[DOUQuery alloc] initWithSubPath:[NSString stringWithFormat:@"/people/%@/collection", user.id] parameters:parameters];
}

- (NSArray *)parseResult:(DOUHttpRequest *)request {
  DoubanFeedSubject *const feedSubject = [[DoubanFeedSubject alloc] initWithData:request.responseData];
  NSArray *const entries = feedSubject.entries;

  NSMutableArray *results = [[NSMutableArray alloc] init];
  [entries each:^(DoubanEntrySubject *entry) {
    DoubanEntrySubject *subject = [[DoubanEntrySubject alloc] initWithXMLElement:[[[entry XMLElement] elementsForName:@"db:subject"] objectAtIndex:0] parent:nil];
    [results addObject:subject];
  }];
  return results;
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