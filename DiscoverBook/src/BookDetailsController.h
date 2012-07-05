#import <UIKit/UIKit.h>
#import "DOUAPIEngine.h"

@interface BookDetailsController : UIViewController  <DOUHttpRequestDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *container;

@property (strong, nonatomic) IBOutlet UIImageView *bookImage;
@property (strong, nonatomic) IBOutlet UILabel *bookTitle;
@property (strong, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) IBOutlet UILabel *publisher;
@property (strong, nonatomic) IBOutlet UILabel *publishDate;
@property (strong, nonatomic) IBOutlet UILabel *rate;
@property (strong, nonatomic) IBOutlet UILabel *numberOfRaters;
@property (strong, nonatomic) IBOutlet UITextView *summary;

@property (strong, nonatomic) NSString *bookDetailsUrl;
@property (strong, nonatomic) NSString *bookCollectionUrl;
- (IBAction)addToWish:(id)sender;

@end
