#import "SearchHandler_protected.h"
#import "DOUQuery.h"
#import "DOUAPIEngine.h"


@implementation SearchHandler {

}

@synthesize userTitle = _userTitle;
@synthesize title = _title;
@synthesize delegate = _delegate;

- (void)loadListFrom:(int)startIndex {
  DOUQuery *query = [self createQuery:startIndex];
  DOUService *service = [DOUService sharedInstance];
  DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {
    if (!request.error && _delegate) {
      [_delegate handleResult:[self parseResult:request] startFrom:startIndex withRequest:request];
    }
  };
  [service get:query callback:completionBlock];
}
@end