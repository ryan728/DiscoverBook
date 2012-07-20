#import "Book.h"
#import "DoubanEntrySubject.h"

@implementation Book

#pragma mark - Properties
@synthesize isbn = _isbn;
@synthesize imageUrl = _imageUrl;
@synthesize title = _title;

- (Book *)initWithEntry:(DoubanEntrySubject *)bookEntry {
  if ((self = [super init]))
  {
    _isbn = bookEntry.isbn;
    _imageUrl = [bookEntry linkWithRelAttributeValue:@"image"].href;
    _title = bookEntry.title.stringValue;
  }

  return self;
}
@end
