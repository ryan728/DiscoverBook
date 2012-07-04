#import "TWImageView+Additions.h"
#import "AFNetworking.h"

@implementation UIImageView (Additions)

-(void) setImageWithAnimation:(NSURL*)imageUrl andPlaceHolder:(UIImage *)placeHolder {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
  [self setImageWithURLRequest:request placeholderImage:placeHolder success:^void(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    self.alpha = 0.0;
    [UIView animateWithDuration:1.0 animations:^(void) {
      self.alpha = 1.0f;
    }];
  } failure:nil];
}
@end
