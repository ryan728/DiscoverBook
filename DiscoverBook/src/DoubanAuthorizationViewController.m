#import "DoubanAuthorizationViewController.h"
#import "GlobalConfig.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "NSString+Additions.h"

@implementation DoubanAuthorizationViewController

@synthesize webView = _webView;
@synthesize authDelegate = _authDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.webView.delegate = self;
  [self.webView loadRequest: [self createRequest]];
}

- (NSURLRequest *)createRequest {
  NSString *str = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code", kAPIKey, kRedirectUrl];
  NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  return [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (BOOL)networkNotWork {
  return !([[Reachability reachabilityForInternetConnection] isReachable]);
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSString *const urlString = request.URL.absoluteString;
  if ([urlString hasPrefix:kRedirectUrl]) {
    NSString *const authQuery = request.URL.query;
    NSMutableDictionary *const parsedQueryDictionary = [authQuery explodeToDictionaryInnerGlue:@"=" outterGlue:@"&"];
    NSString *code = [parsedQueryDictionary objectForKey:@"code"];
    
    if (self.authDelegate) {
      [self.authDelegate validateAuthorizationCode:code];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    return NO;
  }
  return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  NSLog(@"---------------- error.description = %@", error.description);
  if ([self networkNotWork]) {
    [self.view makeNetworkToast];
  }
  [self dismissModalViewControllerAnimated:YES];
}

@end
