#import <Foundation/Foundation.h>
#import "DOUAPIEngine.h"

@interface BookDetailController : UIViewController <DOUHttpRequestDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *authorLabel;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UITextView *introTextView;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

- (id)initWithBookId:(NSString *)identifier;
- (IBAction)search:(id)sender;
@end