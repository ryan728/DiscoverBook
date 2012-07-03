#import "SearchResultLabel.h"

@implementation SearchResultLabel
@synthesize matcher = matcher_;

- (id)initWithText:(NSString *)text andCenter:(CGPoint)center {
  self = [self init];
  if (self) {
    self.text = text;
    self.backgroundColor = [UIColor yellowColor];
    [self sizeToFit];
    CGSize frameSize = self.frame.size;
    self.frame = CGRectMake(center.x - frameSize.width / 2, center.y - frameSize.height / 2, frameSize.width, frameSize.height);
  }
  return self;
}


@end
