@interface SearchController : UIViewController <UIScrollViewDelegate>
@property(nonatomic, copy) NSString *term;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
//@property(nonatomic, strong) IBOutlet UIView *background;

@end