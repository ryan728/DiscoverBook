#import "ContactSearchHandler.h"
#import "User.h"
#import "Macros.h"
#import "DOUQuery.h"
#import "DoubanFeedPeople.h"
#import "DOUAPIEngine.h"
#import "NSArray+Additions.h"
#import "GlobalConfig.h"

@implementation ContactSearchHandler {

}

- (DOUQuery *)createQuery:(int)startIndex {
  User *user = [User findUserWithTitle:self.userTitle];
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array([NSString stringWithFormat:@"%u", kBatchSize], [NSString stringWithFormat:@"%u", startIndex]) forKeys:Array(@"max-results", @"start-index")];
  return [[DOUQuery alloc] initWithSubPath:[NSString stringWithFormat:@"/people/%@/%@", user.id, self.title.lowercaseString] parameters:parameters];
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