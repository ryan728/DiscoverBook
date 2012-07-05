#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class SearchController;

@interface SearchItemView : UIView
- (UIView *)initWithText:(NSString *)string in:(SearchController *)searchController at:(CGPoint)center;
@end
