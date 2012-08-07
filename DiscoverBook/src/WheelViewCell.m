#import "WheelViewCell.h"

@implementation WheelViewCell

- (id)initWithImage:(UIImage*)image {
  self = [super init];
  if (self) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 100, 130);
    [self addSubview:imageView];
  }
  return self;
}
@end
