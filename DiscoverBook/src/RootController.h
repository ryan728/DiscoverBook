#import "DOUAPIEngine.h"

@interface RootController : UIViewController<UIWebViewDelegate, DOUOAuthServiceDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@end
