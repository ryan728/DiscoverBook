#import "Kiwi.h"
#import "RootController.h"
#import "SearchViewController.h"
#import "Macros.h"
#import "MyTableViewController_iphone.h"
#import "User.h"
#import "DOUAPIEngine.h"

SPEC_BEGIN(RootControllerSpec)

describe(@"RootControllerSpec", ^{

  __block RootController *controller;
  __block DOUOAuthStore *authStore;

  beforeEach (^void() {
    authStore = [DOUOAuthStore mock]; 
    [DOUOAuthStore stub:@selector(sharedInstance) andReturn:authStore];
    [[authStore should]receive:@selector(hasValidAccessToken) andReturn:theValue(YES) withCountAtLeast:0];
    controller = [[RootController alloc] init];
  });

  it(@"should prepare search segue", ^{
    UISearchBar *searchBar = [UISearchBar mock];
    [[searchBar should] receive:@selector(text) andReturn:@"search_text"];
    controller.searchBar = searchBar;
    UIStoryboardSegue *const segue = [UIStoryboardSegue mock];
    SearchViewController const *searchViewController = [[SearchViewController alloc] init];
    [[segue should] receive:@selector(identifier) andReturn:@"search" withCount:2];
    [[segue should] receive:@selector(destinationViewController) andReturn:searchViewController];

    [controller prepareForSegue:segue sender:self];

    [[searchViewController.term should] equal: @"search_text"];
  });

  it(@"should prepare show user info segue", ^{
    UIStoryboardSegue *const segue = [UIStoryboardSegue mock];
    [[segue should] receive:@selector(identifier) andReturn:@"showUserInfo" withCount:2];
    UITabBarController *tabBarController = [UITabBarController mock];
    MyTableViewController_iphone *viewController1 = [MyTableViewController_iphone mock];
    MyTableViewController_iphone *viewController2 = [MyTableViewController_iphone mock];
    NSArray *viewControllers = Array(viewController1, viewController2);
    [[tabBarController should]receive:@selector(viewControllers) andReturn:viewControllers];
    [[segue should] receive:@selector(destinationViewController) andReturn:tabBarController];

    [[[viewController1 should] receive] loadData];
    [[[viewController2 should] receive] loadData];

    [controller prepareForSegue:segue sender:self];
  });

  it(@"should show sign out button if has valide access token when view will appear", ^{
    UIButton *const signOutButton = [UIButton mock];
    controller.signOutButton = signOutButton;
    [[[signOutButton should] receive] setHidden:NO];
    [[[signOutButton should] receive] setAlpha:1];
    
    [controller viewWillAppear:YES];
  });

  it(@"should show user name in button if has default user when view will appear", ^{
    [User clearDefaultUser];
    NSUserDefaults *const userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"id" forKey:@"userId"];
    [userDefaults setObject:@"name" forKey:@"userName"];
    [userDefaults synchronize];
    UIButton *const woDuButton = [UIButton mock];
    [[woDuButton should] receive:@selector(setTitle:forState:) withArguments:@"name", theValue(UIControlStateNormal)];
    controller.woDuButton = woDuButton;

    [controller viewWillAppear:YES];
  });
});

SPEC_END
