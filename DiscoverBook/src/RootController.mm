#import "RootController.h"
#import "NSString+Additions.h"
#import "MyBookController.h"
#import "User.h"
#import "SearchViewController.h"
#import "NSArray+Additions.h"
#import "DoubanService.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "GlobalConfig.h"
#import "DoubanAuthorizationViewController.h"

@implementation RootController {
  DoubanService *doubanService_;
}
#pragma mark - Properties

@synthesize searchBar = searchBar_;
@synthesize signOutButton = signOutButton_;
@synthesize woDuButton = woDuButton_;

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
  if (user && authStore.hasValidAccessToken) {
    [woDuButton_ setTitle:user.title forState:UIControlStateNormal];
  }
  [super viewWillAppear:animated];
}

- (BOOL)networkNotWork {
  return !([[Reachability reachabilityForInternetConnection] isReachable]);
}

- (IBAction)woDu:(id)sender {
  if ([self networkNotWork]) {
    [self.view makeNetworkToast];
    return;
  }
  DOUOAuthStore *const authStore = [DOUOAuthStore sharedInstance];
  if (!authStore.hasValidAccessToken) {
    DoubanAuthorizationViewController *authorizationController = [self.storyboard instantiateViewControllerWithIdentifier:@"doubanAuthorizationController"];
    authorizationController.modalPresentationStyle = UIModalPresentationFormSheet;
    authorizationController.authDelegate = self;
    [self presentModalViewController:authorizationController animated:YES];
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

- (void)validateAuthorizationCode:(NSString *)code{
  DOUOAuthService *authService = [DOUOAuthService sharedInstance];
  authService.authorizationURL = kTokenUrl;
  authService.delegate = self;
  authService.clientId = kAPIKey;
  authService.clientSecret = kPrivateKey;
  authService.callbackURL = kRedirectUrl;
  authService.authorizationCode = code;
  
  [authService validateAuthorizationCodeWithCallback:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self performSegueWithIdentifier:@"search" sender:self];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [searchBar_ resignFirstResponder];
}

#pragma mark - DOUOAuthServiceDelegate

- (void)OAuthClient:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic {
  DOUOAuthStore *const authStore = [DOUOAuthStore sharedInstance];
  if (authStore.hasValidAccessToken) {
    NSLog(@"store.accessToken = %@", authStore.accessToken);
    [[[DoubanService alloc]init] fetchUserInfo];
    [self performSegueWithIdentifier:@"showUserInfo" sender:self];
  }
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
  NSLog(@"-------------------------------failed®!");
}
@end
