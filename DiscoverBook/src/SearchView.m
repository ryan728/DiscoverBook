#import "SearchView.h"


@implementation SearchView {

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  NSLog(@"parent event = %@", event);
  return [super hitTest:point withEvent:event];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"jparent touch begin q");
  [super touchesBegan:touches withEvent:event];
}



@end