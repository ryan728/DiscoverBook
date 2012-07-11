#import "RootController.h"
#import "NSString+Additions.h"
#import "MyBookController.h"
#import "User.h"
#import "SearchViewController.h"
#import "NSArray+Additions.h"
#import "DoubanService.h"

@implementation RootController {
  UIWebView *webView_;
  DoubanService *doubanService_;
}
#pragma mark - Properties

@synthesize searchBar = searchBar_;
@synthesize signOutButton = signOutButton_;
@synthesize woDuButton = woDuButton_;

static NSString *const kAPIKey = @"0f08a77e67e884452d19f67b37b98ccf";
static NSString *const kPrivateKey = @"bec2de010015fa6e";
static NSString *const kRedirectUrl = @"http://www.douban.com/location/mobile";

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    doubanService_ = [[DoubanService alloc]init];
  }
  return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [super prepareForSegue:segue sender:sender];
  if ([segue.identifier isEqualToString:@"search"]) {
    SearchViewController *searchController = segue.destinationViewController;
    searchController.term = searchBar_.text;
  }
  if ([segue.identifier isEqualToString:@"showUserInfo"]) {
    UITabBarController *tabBarController = segue.destinationViewController;
    NSArray *const viewControllers = tabBarController.viewControllers;
    [viewControllers each:^(MyTableViewController *controller) {
      [controller loadData];
    }];
  }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
  DOUOAuthStore *const authStore = [DOUOAuthStore sharedInstance];
  signOutButton_.hidden = !authStore.hasValidAccessToken;
  signOutButton_.alpha = 1.0f;

  User *const user = [User defaultUser];
  if (user) {
    [woDuButton_ setTitle:user.title forState:UIControlStateNormal];
  }
  [super viewWillAppear:animated];
}

- (IBAction)woDu:(id)sender {
  DOUOAuthStore *const authStore = [DOUOAuthStore sharedInstance];
  if (!authStore.hasValidAccessToken) {
    [self initWebView];
    [self.view addSubview:webView_];
  } else {
    [doubanService_ fetchUserInfo];
    [self performSegueWithIdentifier:@"showUserInfo" sender:self];
  }
}

- (IBAction)signOut:(id)sender {
  DOUOAuthService *authService = [DOUOAuthService sharedInstance];
  [authService logout];
  [User clearDefaultUser];
  [woDuButton_ setTitle:@"Wo Du" forState:UIControlStateNormal];

  [UIView animateWithDuration:1.0
                   animations:^void() {
                     signOutButton_.alpha = 0;
                   }
                   completion:^void(BOOL finished) {
                     signOutButton_.hidden = YES;
                   }
  ];
}

- (void)initWebView {
  webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,
          self.view.bounds.size.width, self.view.bounds.size.height - 49)];
  webView_.scalesPageToFit = YES;
  webView_.delegate = self;
  [webView_ loadRequest:[self createRequest]];
}


- (NSURLRequest *)createRequest {
  NSString *str = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code", kAPIKey, kRedirectUrl];
  NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  return [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSString *const urlString = request.URL.absoluteString;
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

    [authService validateAuthorizationCodeWithCallback:nil];
    return NO;
  }
  return YES;
}

- (void)dismissWebView {
  [UIView animateWithDuration:1.0
                   animations:^void() {
                     webView_.alpha = 0;
                   }
                   completion:^void(BOOL finished) {
                     if (finished) {
                       [webView_ removeFromSuperview];
                     }
                   }
  ];
}

#pragma mark - DOUOAuthServiceDelegate

- (void)OAuthClient:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic {
  DOUOAuthStore *const authStore = [DOUOAuthStore sharedInstance];
  NSLog(@"store.accessToken = %@", authStore.accessToken);
  [doubanService_ fetchUserInfo];
  [self dismissWebView];
  [self performSegueWithIdentifier:@"showUserInfo" sender:self];
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
  NSLog(@"failed®!");
  [self dismissWebView];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self performSegueWithIdentifier:@"search" sender:self];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [searchBar_ resignFirstResponder];
}

@end
