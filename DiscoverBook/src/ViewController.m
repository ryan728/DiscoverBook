#import "ViewController.h"
#import "NSString+Additions.h"

@interface ViewController ()

@property(nonatomic, retain) UIWebView *webView;

@end

@implementation ViewController

static NSString *const kAPIKey = @"0f08a77e67e884452d19f67b37b98ccf";
static NSString *const kPrivateKey = @"bec2de010015fa6e";
static NSString *const kRedirectUrl = @"http://www.douban.com/location/mobile";

@synthesize webView = webView_;

- (NSURLRequest *)createRequest {
  NSString *str = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code", kAPIKey, kRedirectUrl];
  NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
  return request;
}

- (void)initWebView {
  webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,
          self.view.bounds.size.width, self.view.bounds.size.height - 49)];
  webView_.scalesPageToFit = YES;
  webView_.delegate = self;
  [webView_ loadRequest:[self createRequest]];
}

- (BOOL)hasAccessToken {
  DOUOAuthStore *const store = [DOUOAuthStore sharedInstance];
  return store.accessToken != nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  if ([self hasAccessToken]) {
    [self initWebView];
    [self.view addSubview:webView_];
  }

  DOUService *service = [DOUService sharedInstance];
  service.clientId = kAPIKey;
  service.clientSecret = kPrivateKey;
  service.apiBaseUrlString = kHttpsApiBaseUrl;
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dismissWebView {
  [UIView animateWithDuration:1.0 animations:^void() {
    webView_.alpha = 0;
  }                completion:^void(BOOL finished) {
    if (finished) {
      [webView_ removeFromSuperview];
    }
  }];
}

- (void)printAccessToken {
  DOUOAuthStore *store = [DOUOAuthStore sharedInstance];
  NSLog(@"store.accessToken = %@", store.accessToken);
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSString *const urlString = request.URL.absoluteString;

  if ([self hasAccessToken]) {
    [self printAccessToken];
    [self dismissWebView];
    return NO;
  }

  if ([urlString hasPrefix:kRedirectUrl]) {
    NSString *const authQuery = request.URL.query;
    NSMutableDictionary *const parsedQueryDictionary = [authQuery explodeToDictionaryInnerGlue:@"=" outterGlue:@"&"];
    NSString *code = [parsedQueryDictionary objectForKey:@"code"];

    DOUOAuthService *authService = [DOUOAuthService sharedInstance];
    authService.authorizationURL = kTokenUrl;
    authService.delegate = self;
    authService.clientId = kAPIKey;
    authService.clientSecret = kPrivateKey;
    authService.callbackURL = kRedirectUrl;
    authService.authorizationCode = code;

    [authService validateAuthorizationCodeWithCallback:^{
      [self printAccessToken];
    }];
    return NO;
  }
  return YES;
}
#pragma mark end

#pragma mark - DOUOAuthServiceDelegate

- (void)OAuthClient:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic {
  NSLog(@"success!");
  [self dismissWebView];
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
  NSLog(@"failed®!");
}

#pragma mark end
@end
