#import "MyContactController.h"
#import "User.h"
#import "DOUQuery.h"
#import "DOUService.h"
#import "DoubanFeedSubject.h"
#import "AFNetworking.h"
#import "DOUAPIEngine.h"
#import "DoubanFeedPeople.h"
#import "Macros.h"

@implementation MyContactController

static UIImage *DEFAULT_CONTACT_ICON = nil;

+ (void)initialize {
  NSString *defaultBookCoverPath = [[NSBundle mainBundle] pathForResource:@"default_book_cover" ofType:@"jpg"];
  DEFAULT_CONTACT_ICON = [UIImage imageWithContentsOfFile:defaultBookCoverPath];
}

- (DOUQuery *)createQuery:(int)startIndex {
  User *user = [User defaultUser];
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array([NSString stringWithFormat:@"%u", RESULT_BATCH_SIZE], [NSString stringWithFormat:@"%u", startIndex]) forKeys:Array(@"max-results", @"start-index")];
  return [[DOUQuery alloc] initWithSubPath:[NSString stringWithFormat:@"/people/%@/contacts", user.id] parameters:parameters];
}

- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath {
  DoubanEntryPeople *contact = [self.myEntries objectAtIndex:indexPath.row];
  cell.textLabel.text = contact.title.stringValue;

  NSURL *const imageUrl = [[contact linkWithRelAttributeValue:@"icon"] URL];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
  [cell.imageView setImageWithURLRequest:request placeholderImage:DEFAULT_CONTACT_ICON success:^void(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    cell.imageView.alpha = 0.0;
    [UIView animateWithDuration:1.0 animations:^(void) {
      cell.imageView.alpha = 1.0f;
    }];
  } failure:nil];

  cell.detailTextLabel.text = contact.signature.content;
}

- (NSArray *)parseResult:(DOUHttpRequest *)request {
  DoubanFeedPeople *const feedSubject = [[DoubanFeedPeople alloc] initWithData:request.responseData];
  return feedSubject.entries;
}


@end
