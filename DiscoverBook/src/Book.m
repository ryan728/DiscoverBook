#import "Book.h"
#import "DoubanEntrySubject.h"
#import "DoubanFeedSubject.h"
#import "NSArray+Additions.h"
#import "DOUAPIEngine.h"


@implementation Book

#pragma mark - Properties
@synthesize isbn = _isbn;
@synthesize imageUrl = _imageUrl;
@synthesize title = _title;

- (Book *)initWithEntry:(DoubanEntrySubject *)bookEntry {
  if ((self = [super init]))
  {
    _isbn = bookEntry.isbn;
    _imageUrl = [[bookEntry linkWithRelAttributeValue:@"image"] URL];
    _title = bookEntry.title.stringValue;
    NSMutableString *authors = [NSMutableString string];
    [bookEntry.authors each:^(GDataAtomAuthor *author) {
      [authors appendString:author.name];
    }];
  }

  return self;
}
@end
