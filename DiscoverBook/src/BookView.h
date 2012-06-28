#import <Foundation/Foundation.h>

@class DoubanEntrySubject;


@interface BookView : UIView

- (BookView *)initWithBook:(DoubanEntrySubject *)book at:(CGPoint)point;

- (void)wobble;

- (void)clearAnimation;
@end