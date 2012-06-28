#import "BookView.h"
#import "DoubanEntrySubject.h"
#import <QuartzCore/QuartzCore.h>

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 1.0


@implementation BookView {
  DoubanEntrySubject *_book;
  UIView *_scaleView;
}

- (void)initViews {

  _scaleView = [[UIView alloc] initWithFrame:CGRectMake(28, 0, 54, 64)];
  _scaleView.backgroundColor = [UIColor clearColor];
  _scaleView.layer.cornerRadius = 10.0f;
  _scaleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _scaleView.layer.borderWidth = 2.0f;

  NSURL *const imageUrl = [[_book linkWithRelAttributeValue:@"image"] URL];
  NSData *const imageData = [NSData dataWithContentsOfURL:imageUrl];
  UIImage *const image = [UIImage imageWithData:imageData];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 2, 50, 60)];

  imageView.layer.backgroundColor = [UIColor clearColor].CGColor;
  imageView.layer.cornerRadius = 10.0f;
  imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
  imageView.layer.borderWidth = 1.5f;
  imageView.layer.shadowColor = [UIColor blackColor].CGColor;
  imageView.layer.shadowOpacity = 0.8;
  imageView.layer.shadowRadius = 3.0;
  imageView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
  imageView.layer.masksToBounds = YES;

  imageView.image = image;

  UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 110, 30)];
  title.backgroundColor = [UIColor clearColor];
  title.text = _book.title.stringValue;
  title.numberOfLines = 2;
  title.font = [UIFont systemFontOfSize:10.0];
  title.textAlignment = UITextAlignmentCenter;

  [self addSubview:imageView];
  [self addSubview:title];
}

- (BookView *)initWithBook:(DoubanEntrySubject *)book at:(CGPoint)point {
  self = [self initWithFrame:CGRectMake(point.x - 40, point.y - 40, 110, 90)];
  if (self) {
    _book = book;
    [self initViews];
  }

  return self;
}

- (void)wobble {

//  NSInteger randomInt = arc4random() % 500;
//  float r = (randomInt / 500.0) + 0.5;

//  CGAffineTransform leftWobble = CGAffineTransformMakeRotation(degreesToRadians( (kAnimationRotateDeg * -1.0) - r ));
//  CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDeg + r ));
  [self addSubview:_scaleView];
  CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);

//  self.transform = leftWobble;  // starting point

  [[_scaleView layer] setAnchorPoint:CGPointMake(0.5, 0.5)];

  [UIView animateWithDuration:0.3
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat //| UIViewAnimationOptionAutoreverse
                   animations:^{
                     [UIView setAnimationRepeatCount:NSNotFound];
                     _scaleView.transform = scale;
//                     self.transform = rightWobble;
                   }
          completion:nil];


//  CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-10.0));
//  CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(10.0));
//
//  self.transform = leftWobble;  // starting point
//
//  [UIView beginAnimations:@"wobble" context:nil];
//  [UIView setAnimationRepeatAutoreverses:YES];
//  [UIView setAnimationRepeatCount:0]; // adjustable
//  [UIView setAnimationDuration:0.5];
//  [UIView setAnimationDelegate:self];
//  self.transform = rightWobble; // end here & auto-reverse
//  [UIView commitAnimations];
}

- (void)clearAnimation {
  [_scaleView.layer removeAllAnimations];
  [_scaleView setTransform:CGAffineTransformIdentity];
  [_scaleView removeFromSuperview];
}
@end