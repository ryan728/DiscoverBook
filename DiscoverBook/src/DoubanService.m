#import "DoubanService.h"
#import "DOUQuery.h"
#import "DoubanEntryPeople.h"
#import "User.h"
#import "GlobalConfig.h"
#import "Macros.h"
#import "DoubanFeedSubject.h"
#import "NSArray+Additions.h"
#import "Book.h"
#import "DOUAPIEngine.h"

@implementation DoubanService

static NSArray *kBookTags = nil;

+(void) initialize{
  NSError *error = nil;
  NSString *filePath =[[NSBundle mainBundle] pathForResource:@"tags" ofType:@"txt"];
  kBookTags = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
}

- (void)fetchUserInfo {
  DOUQuery *query = [[DOUQuery alloc] initWithSubPath:@"/people/@me" parameters:nil];

  DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {
    if (!request.error) {
      DoubanEntryPeople *people = [[DoubanEntryPeople alloc] initWithData:request.responseData];
      [User initDefaultUser:people];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoFetched" object:nil];
    } else {
      NSLog(@"request.error.description = %@", request.error.description);
    }
  };
  [[DOUService sharedInstance] get:query callback:completionBlock];
}

- (void)fetchRandomBooksWithCallBack:(void (^)(NSArray *, DOUHttpRequest *))callback {
  NSInteger tagIndex = arc4random() % kBookTags.count;
  NSInteger startIndex = arc4random() % 10;
  
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array([kBookTags objectAtIndex:tagIndex], [NSString stringWithFormat:@"%d", kCellCount], [NSString stringWithFormat:@"%d", startIndex]) forKeys:Array(@"tag", @"max-results", @"start-index")];
  DOUQuery *query = [[DOUQuery alloc] initWithSubPath:@"/book/subjects" parameters:parameters];
  query.apiBaseUrlString = kHttpApiBaseUrl;
  
  __weak DOUHttpRequest *request = [DOUHttpRequest requestWithURL:[query requestURL]];
  NSMutableArray *result = [NSMutableArray array];
  request.completionBlock = ^(void){
    if (!request.error) {
      DoubanFeedSubject *const feedSubject = [[DoubanFeedSubject alloc] initWithData:request.responseData];
      NSArray *const entries = feedSubject.entries;
      [entries eachWithIndex:^(DoubanEntrySubject *item, NSUInteger i) {
        [result addObject:[[Book alloc] initWithEntry:item]];
      }];
    }
    
    callback(result, request);
  };
  [request startAsynchronous];
}
@end
