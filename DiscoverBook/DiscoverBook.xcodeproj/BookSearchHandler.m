#import "BookSearchHandler.h"
#import "User.h"
#import "Book.h"
#import "Macros.h"
#import "DOUQuery.h"
#import "DoubanFeedSubject.h"
#import "DOUAPIEngine.h"
#import "NSArray+Additions.h"
#import "GlobalConfig.h"

@implementation BookSearchHandler {

}

- (DOUQuery *)createQuery:(int)startIndex {
  User *user = [User findUserWithTitle:self.userTitle];
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array(@"book", self.title.lowercaseString, [NSString stringWithFormat:@"%u", kBatchSize], [NSString stringWithFormat:@"%u", startIndex]) forKeys:Array(@"cat", @"status", @"max-results", @"start-index")];
  return [[DOUQuery alloc] initWithSubPath:[NSString stringWithFormat:@"/people/%@/collection", user.id] parameters:parameters];
}

- (NSArray *)parseResult:(DOUHttpRequest *)request {
  DoubanFeedSubject *const feedSubject = [[DoubanFeedSubject alloc] initWithData:request.responseData];
  NSArray *const entries = feedSubject.entries;

  NSMutableArray *results = [[NSMutableArray alloc] init];
  [entries each:^(DoubanEntrySubject *entry) {
    DoubanEntrySubject *subject = [[DoubanEntrySubject alloc] initWithXMLElement:[[[entry XMLElement] elementsForName:@"db:subject"] objectAtIndex:0] parent:nil];
    [results addObject:[[Book alloc] initWithEntry:subject]];
  }];
  return results;
}

@end