#import "WheelViewCell.h"

@implementation WheelViewCell

@synthesize imageView = _imageView;

- (id)initWithImage:(UIImage*)image {
  self = [super init];
  if (self) {
    _imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = CGRectMake(0, 0, 100, 130);
    [self addSubview:self.imageView];
  }
  return self;
}
@end
