#import <UIKit/UIKit.h>
#import "WheelView.h"

@interface RootViewController_iPad : UIViewController <WheelViewDataSource>

@property (nonatomic, strong) IBOutlet WheelView *wheelView;

@end
