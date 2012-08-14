#import "GridCell.h"
#import "TWImageView+Additions.h"
#import <QuartzCore/QuartzCore.h>

@implementation GridCell {
  UIImageView *_iconView;
  UILabel *_titleLabel;
}

@synthesize imageUrl = _imageUrl;
@synthesize title = _title;

- (id) initWithFrame: (CGRect) frame reuseIdentifier:(NSString *) reuseIdentifier
{
  self = [super initWithFrame: frame reuseIdentifier: reuseIdentifier];
  if ( self == nil )
    return nil;
  
  UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.0, 0.0, 72.0, 102.0)
                                                   cornerRadius: 18.0];
  
  _iconView = [[UIImageView alloc] initWithFrame: CGRectMake(40.0, 0.0, 72.0, 102.0)];
  _iconView.backgroundColor = [UIColor clearColor];
  _iconView.opaque = NO;
  _iconView.layer.shadowPath = path.CGPath;
  _iconView.layer.shadowRadius = 20.0;
  _iconView.layer.shadowOpacity = 0.4;
  _iconView.layer.shadowOffset = CGSizeMake( 20.0, 20.0 );
  
  _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 110, 142, 22)];
  _titleLabel.textAlignment = UITextAlignmentCenter;
  _titleLabel.backgroundColor = [UIColor clearColor];
  
  [self.contentView addSubview: _iconView];
  [self.contentView addSubview:_titleLabel];
  
  self.contentView.backgroundColor = [UIColor clearColor];
  self.backgroundColor = [UIColor clearColor];
  
  self.contentView.opaque = NO;
  self.opaque = NO;
  
  self.selectionStyle = AQGridViewCellSelectionStyleNone;
  
  return ( self );
}

- (void) setImageUrl:(NSURL *)imageUrl {
  _imageUrl = imageUrl;
  [_iconView setImageWithAnimation:imageUrl andPlaceHolder:_iconView.image];
}

- (void)setTitle:(NSString *)title {
  _title = title;
  _titleLabel.text = title;
}
@end
