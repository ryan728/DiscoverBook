#import <QuartzCore/QuartzCore.h>
#import "SearchView.h"
#import "NSArray+Additions.h"
#import "SearchResultLabel.h"

@implementation SearchView {

}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
  CGContextSetLineWidth(context, 2.0);

  NSArray *const subViews = [self subviews];

  [subViews each:^void(SearchResultLabel *label) {
    [subViews each:^void(SearchResultLabel *anotherLabel) {
      if (label.matcher + anotherLabel.matcher == 0) {
        CGContextMoveToPoint(context, label.frame.origin.x + label.frame.size.width / 2, label.frame.origin.y + label.frame.size.height / 2);
        CGContextAddLineToPoint(context, anotherLabel.frame.origin.x + anotherLabel.frame.size.width / 2, anotherLabel.frame.origin.y + anotherLabel.frame.size.height / 2);
        CGContextStrokePath(context);
      }
    }];
  }];

  [super drawRect:rect];
}


@end