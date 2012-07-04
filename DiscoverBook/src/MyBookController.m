#import "DOUQuery.h"
#import "DOUAPIEngine.h"
#import "DoubanEntryPeople.h"
#import "DoubanFeedSubject.h"
#import "NSArray+Additions.h"
#import "Macros.h"
#import "User.h"
#import "MyBookController.h"
#import "UIImageView+AFNetworking.h"

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

  NSURL *const imageUrl = [[book linkWithRelAttributeValue:@"image"] URL];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
  [cell.imageView setImageWithURLRequest:request placeholderImage:DEFAULT_BOOK_COVER_IMAGE success:^void(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    cell.imageView.alpha = 0.0;
    [UIView animateWithDuration:1.0 animations:^(void) {
      cell.imageView.alpha = 1.0f;
    }];
  } failure:nil];

  NSMutableString *authors = [NSMutableString string];
  [book.authors each:^(GDataAtomAuthor *author) {
    [authors appendString:author.name];
  }];
  cell.detailTextLabel.text = authors;
}

@end