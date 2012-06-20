#import "ViewController.h"
#import "NSString+Additions.h"

@interface ViewController ()

@property(nonatomic, retain) UIWebView *webView;

@end

@implementation ViewController

static NSString *const kAPIKey = @"0f08a77e67e884452d19f67b37b98ccf";
static NSString *const kPrivateKey = @"Secretbec2de010015fa6e";
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

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"登录";
  [self initWebView];
  [self.view addSubview:webView_];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSURL *const requestUrl = request.URL;
  NSString *const urlString = requestUrl.absoluteString;

  if ([urlString hasPrefix:kRedirectUrl]) {
    NSString *const query = requestUrl.query;
    NSMutableDictionary *const parsedQueryDictionary = [query explodeToDictionaryInnerGlue:@"=" outterGlue:@"&"];
    NSString *code = [parsedQueryDictionary objectForKey:@"code"];

    DOUOAuthService *service = [DOUOAuthService sharedInstance];
    service.authorizationURL = kTokenUrl;
    service.delegate = self;
    service.clientId = kAPIKey;
    service.clientSecret = kPrivateKey;
    service.callbackURL = kRedirectUrl;
    service.authorizationCode = code;

    [service validateAuthorizationCode];
    return NO;
  }
  return YES;
}
#pragma mark end

#pragma mark - DOUOAuthServiceDelegate

- (void)OAuthClient:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic {
  NSLog(@"success!");
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
  NSLog(@"failed®!");
}


@end
