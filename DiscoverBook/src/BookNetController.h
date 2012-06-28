#import "DOUAPIEngine.h"

@class DoubanEntrySubject;
@class BookView;

@interface BookNetController : UIViewController <DOUHttpRequestDelegate>

@property(nonatomic, retain) IBOutlet UIView *canvas;
@property(nonatomic, strong) BookView *bookView;

- (id)initWithBook:(DoubanEntrySubject *)book;

- (IBAction)back:(id)sender;
@end
