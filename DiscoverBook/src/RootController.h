#import "DOUAPIEngine.h"

@interface RootController : UIViewController<UIWebViewDelegate, DOUOAuthServiceDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIButton *signOutButton;
@property (nonatomic, strong) IBOutlet UIButton *woDuButton;

@end
