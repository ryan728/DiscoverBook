#import "DOUService+Additions.h"
#import "DOUQuery.h"
#import "DoubanEntryPeople.h"
#import "User.h"

@implementation DOUService (Additions)

- (void)fetchUserInfo {
  DOUQuery *query = [[DOUQuery alloc] initWithSubPath:@"/people/@me" parameters:nil];

    DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {
      if (!request.error) {
        DoubanEntryPeople *people = [[DoubanEntryPeople alloc] initWithData:request.responseData];
        [User initDefaultUser:people];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoFetched" object:self];
      } else {
        NSLog(@"request.error.description = %@", request.error.description);
      }
    };
    DOUService *service = [DOUService sharedInstance];
    [service get:query callback:completionBlock];
}
@end
