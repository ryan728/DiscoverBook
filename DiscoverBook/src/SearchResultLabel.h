@interface SearchResultLabel : UILabel
@property(nonatomic, assign) int matcher;

-(id) initWithText:(NSString *)text andCenter:(CGPoint)center;

@end
