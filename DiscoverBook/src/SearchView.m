#import <QuartzCore/QuartzCore.h>
#import "SearchView.h"
#import "NSArray+Additions.h"
#import "SearchResultLabel.h"

@implementation SearchView {

}
static short const RADIUS = 150;

//- (void)drawRect:(CGRect)rect {
//  CGContextRef context = UIGraphicsGetCurrentContext();
//  CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//  CGContextSetLineWidth(context, 2.0);
//
////  NSArray *const subViews = [self subviews];
////
////  [subViews each:^void(SearchResultLabel *label) {
////    [subViews each:^void(SearchResultLabel *anotherLabel) {
////      if (label.matcher + anotherLabel.matcher == 0) {
////        CGContextMoveToPoint(context, label.frame.origin.x + label.frame.size.width / 2, label.frame.origin.y + label.frame.size.height / 2);
////        CGContextAddLineToPoint(context, anotherLabel.frame.origin.x + anotherLabel.frame.size.width / 2, anotherLabel.frame.origin.y + anotherLabel.frame.size.height / 2);
////        CGContextStrokePath(context);
////      }
////    }];
////  }];
//  CGContextStrokePath(context);
//
//  [super drawRect:rect];
//}


- (void)scatter {
  const NSUInteger count = self.subviews.count;

  NSMutableArray *originCenters = [NSMutableArray arrayWithCapacity:count - 1];
  NSMutableArray *newCenters = [NSMutableArray arrayWithCapacity:count - 1];

  for (int i = 1; i < count; i++) {
    const double angle = M_PI * 2 / (count - 1) * i;
    SearchResultLabel *label = [self.subviews objectAtIndex:i];
    const CGPoint center = label.center;

    [originCenters addObject:[NSValue valueWithCGPoint:center]];
    CGFloat anotherCenterX = center.x + sin(angle) * RADIUS;
    CGFloat anotherCenterY = center.y - cos(angle) * RADIUS;
    [newCenters addObject:[NSValue valueWithCGPoint:CGPointMake(anotherCenterX, anotherCenterY)]];
  }

  [UIView animateWithDuration:4.0f animations:^void() {
    for (int i = 1; i < count; i++) {
      ((UIView *)[self.subviews objectAtIndex:i]).center = [[newCenters objectAtIndex:i -1] CGPointValue];
    }
  }];


  for (int i = 1; i < count; i++) {

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
    shapeLayer.lineWidth = 1.0f;
    CGPoint oldCenter = [[originCenters objectAtIndex:i-1] CGPointValue];
    CGPoint newCenter = [[newCenters objectAtIndex:i-1] CGPointValue];
//    shapeLayer.frame = CGRectMake(oldCenter.x, oldCenter.y, RADIUS, RADIUS);
    shapeLayer.frame = CGRectMake(1280, 960, RADIUS, RADIUS);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(newCenter.x - oldCenter.x, newCenter.y - oldCenter.y)];

//    [path addLineToPoint:[[newCenters objectAtIndex:0] CGPointValue]];

//    shapeLayer.frame = self.layer.frame;
//  shapeLayer.bounds = CGPathGetBoundingBox(path.CGPath);
  shapeLayer.path = path.CGPath;
    
    [self.layer addSublayer:shapeLayer];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = 4.0f;
    [shapeLayer addAnimation:animation forKey:@"strokeEnd"];
//    CGPathMoveToPoint(path, NULL, center.x, center.y);
//    CGPathAddLineToPoint(path, NULL, label.center.x, label.center.y);
  }
}
@end