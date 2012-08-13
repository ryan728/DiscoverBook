#import <UIKit/UIKit.h>
#import "WheelView.h"
#import "RootViewController_SegueHandler.h"

@interface RootViewController_iPad : RootController <WheelViewDataSource>

@property (nonatomic, strong) IBOutlet WheelView *wheelView;

@end
