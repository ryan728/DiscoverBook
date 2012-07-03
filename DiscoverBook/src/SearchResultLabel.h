@interface SearchResultLabel : UILabel
@property(nonatomic, assign) int matcher;

@property(nonatomic, weak) UIScrollView *scrollView;

-(id) initWithText:(NSString *)text andCenter:(CGPoint)center;

@end
