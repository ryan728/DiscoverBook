#import <UIKit/UIKit.h>

@protocol DoubanAuthorizationViewDelegate;

@interface DoubanAuthorizationViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) id<DoubanAuthorizationViewDelegate> authDelegate;

@end


@protocol DoubanAuthorizationViewDelegate

- (void)validateAuthorizationCode:(NSString *)code;

@end