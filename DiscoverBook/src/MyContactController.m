#import "MyContactController.h"
#import "User.h"
#import "DOUQuery.h"
#import "DOUService.h"
#import "DoubanFeedSubject.h"
#import "DoubanFeedPeople.h"
#import "Macros.h"
#import "TWImageView+Additions.h"
#import "NSArray+Additions.h"

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
  User *user = [self.myEntries objectAtIndex:indexPath.row];
  cell.textLabel.text = user.title;
  cell.detailTextLabel.text = user.signature;
  [cell.imageView setImageWithAnimation:user.imageUrl andPlaceHolder:DEFAULT_CONTACT_ICON];
}

- (NSArray *)parseResult:(DOUHttpRequest *)request {
  DoubanFeedPeople *const feedSubject = [[DoubanFeedPeople alloc] initWithData:request.responseData];
  NSMutableArray *results = [[NSMutableArray alloc] init];

  [feedSubject.entries each:^void(DoubanEntryPeople *people) {
    [results addObject:[[User alloc] initWithDoubanEntryPeople:people]];
  }];
  return results;
}


@end
