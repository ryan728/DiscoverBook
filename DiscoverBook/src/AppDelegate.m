#import "AppDelegate.h"
#import "IntrospectManager.h"
#import "DOUService.h"
#import "DOUAPIEngine.h"

static NSString *const kAPIKey = @"0f08a77e67e884452d19f67b37b98ccf";
static NSString *const kPrivateKey = @"bec2de010015fa6e";
static NSString *const kRedirectUrl = @"http://www.douban.com/location/mobile";

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [TestFlight takeOff:@"9fdd4ffe966bdba0fa4d8191c7bb2452_MTA1MTg4MjAxMi0wNi0yOSAwMToxNTo1MS43NTIyNjI"];
  [IntrospectManager loadIntrospect];

  DOUService *service = [DOUService sharedInstance];
  service.clientId = kAPIKey;
  service.clientSecret = kPrivateKey;
  service.apiBaseUrlString = kHttpsApiBaseUrl;

  return YES;
}

@end
