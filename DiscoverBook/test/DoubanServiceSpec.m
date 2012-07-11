#import "DoubanService.h"
#import "Kiwi.h"
#import "User.h"
#import "DOUQuery.h"

SPEC_BEGIN(DoubanServiceSpec)

describe(@"DoubanService", ^{
  it(@"should init default user after fetching", ^{
    id serviceMock = [KWMock nullMockForClass:[DOUService class]];
    KWCaptureSpy *spy1 = [serviceMock captureArgument:@selector(get:callback:) atIndex:0];
    KWCaptureSpy *spy2 = [serviceMock captureArgument:@selector(get:callback:) atIndex:1];
    [DOUService stub:@selector(sharedInstance) andReturn:serviceMock];
    
    DoubanService *service = [[DoubanService alloc]init];
    [service fetchUserInfo];
    
    DOUQuery *query = spy1.argument;
    [[query.subPath should]equal:@"/people/@me"];
    
    DOUReqBlock completionBlock = spy2.argument;
    DOUHttpRequest *request = [DOUHttpRequest mock];
    
    NSString *path = [[NSBundle bundleForClass:[User class]] pathForResource:@"people_entry" ofType:@"xml"];
    [[request should]receive:@selector(error) andReturn:nil];
    [[request should]receive:@selector(responseData) andReturn:[NSData dataWithContentsOfFile:path]];
    completionBlock(request);
    
    User *user = [User defaultUser];
    [[user.id should]equal:@"mechiland"];
  });
});

SPEC_END
