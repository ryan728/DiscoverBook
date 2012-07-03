#import "SearchResultLabel.h"

@implementation SearchResultLabel {
  CGPoint currentPoint;
}
@synthesize matcher = matcher_;
@synthesize scrollView = _scrollView;


- (id)initWithText:(NSString *)text andCenter:(CGPoint)center {
  self = [self init];
  if (self) {
    self.text = text;
    self.backgroundColor = [UIColor yellowColor];
    [self sizeToFit];
    CGSize frameSize = self.frame.size;
    self.frame = CGRectMake(center.x - frameSize.width / 2, center.y - frameSize.height / 2, frameSize.width, frameSize.height);
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  _scrollView.scrollEnabled = NO;
  _scrollView.userInteractionEnabled = NO;
  currentPoint = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint activePoint = [[touches anyObject] locationInView:self];

  CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - currentPoint.x),
          self.center.y + (activePoint.y - currentPoint.y));

  self.center = newPoint;
  [[_scrollView.subviews objectAtIndex:0] setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"touch ended");
  _scrollView.scrollEnabled = YES;
  _scrollView.userInteractionEnabled = YES;
}

@end
