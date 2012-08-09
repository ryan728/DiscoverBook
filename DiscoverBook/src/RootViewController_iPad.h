#import <UIKit/UIKit.h>
#import "WheelView.h"
#import "RootController.h"

@interface RootViewController_iPad : RootController <WheelViewDataSource>

@property (nonatomic, strong) IBOutlet WheelView *wheelView;

@end
