#import "BookDetailController.h"
#import "DOUQuery.h"
#import "DOUService.h"
#import "DoubanEntrySubject.h"
#import "BookNetController.h"

@interface BookDetailController ()

@property(nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) DoubanEntrySubject *book;

@end

@implementation BookDetailController

@synthesize bookId = _bookId;
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize authorLabel = _authorLabel;
@synthesize priceLabel = _priceLabel;
@synthesize introTextView = _introTextView;
@synthesize searchButton = _searchButton;
@synthesize book = _book;

- (id)initWithBookId:(NSString *)identifier {
  self = [self init];
  if (self) {
    _bookId = identifier;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSBundle mainBundle] loadNibNamed:@"BookDetailView" owner:self options:nil];
  _searchButton.enabled = NO;
  DOUHttpRequest *request = [DOUHttpRequest requestWithURL:[NSURL URLWithString:_bookId]];
  request.delegate = self;
  [request setRequestMethod:@"GET"];
  [request startAsynchronous];
}

- (void)requestFinished:(DOUHttpRequest *)request {
  _book = [[DoubanEntrySubject alloc] initWithData:request.responseData];
  _titleLabel.text = _book.title.stringValue;
  _authorLabel.text = ((GDataAtomAuthor *)[[_book authors] objectAtIndex:0]).name;
  _priceLabel.text = _book.price;
  NSURL *const imageUrl = [[_book linkWithRelAttributeValue:@"image"] URL];
  NSData *const imageData = [NSData dataWithContentsOfURL:imageUrl];
  UIImage *const image = [UIImage imageWithData:imageData];
  _imageView.image = image;
  _introTextView.text = _book.summary.stringValue;
  _searchButton.enabled = YES;
}

- (void)requestFailed:(DOUHttpRequest *)request {
  NSLog(@"request.error.description = %@", request.error.description);
}

- (IBAction)search:(id)sender {
  [self presentModalViewController:[[BookNetController alloc] initWithBook:_book] animated:YES];
}

@end