#import "DOUAPIEngine.h"
#import "DoubanAuthorizationViewController.h"

@interface RootController : UIViewController<DOUOAuthServiceDelegate, UISearchBarDelegate, DoubanAuthorizationViewDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIButton *signOutButton;
@property (nonatomic, strong) IBOutlet UIButton *woDuButton;

@end
