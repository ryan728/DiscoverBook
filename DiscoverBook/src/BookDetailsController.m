#import "BookDetailsController.h"
#import "DoubanEntrySubject.h"
#import "AFNetworking.h"
#import "NSArray+Additions.h"
#import "DoubanFeedEvent.h"

@implementation BookDetailsController {
    DoubanEntrySubject *entrySubject;
}

@synthesize container = _container;
@synthesize bookImage = _bookImage;
@synthesize bookTitle = _bookTitle;
@synthesize author = _author;
@synthesize publisher = _publisher;
@synthesize publishDate = _publishDate;
@synthesize rate = _rate;
@synthesize numberOfRaters = _numberOfRaters;
@synthesize summary = _summary;
@synthesize bookDetailsUrl = _bookDetailsUrl;
@synthesize bookCollectionUrl = _bookCollectionUrl;


static UIImage *DEFAULT_BOOK_COVER_IMAGE = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_container setScrollEnabled:YES];

}

- (void)loadBookDetails {

    NSURL *const url = [[NSURL alloc] initWithString:_bookDetailsUrl];
    DOUHttpRequest *request = [[DOUHttpRequest alloc] initWithURL:url];
    request.delegate = self;

    [request startAsynchronous];
// Douban API said when request with auth key, it will include current user collection url info, but the service will give exception below

//    DOUService *service = [DOUService sharedInstance];
//    NSString *const subPath = [_bookDetailsUrl substringFromIndex:NSMaxRange([_bookDetailsUrl rangeOfString:@"com"])];
//    DOUQuery *const query = [[DOUQuery alloc] initWithSubPath:subPath parameters:nil];
//    [service get:query delegate:self];
}

- (void)setBookSummaryInfo:(DoubanEntrySubject *)entrySubject {
    [_summary setText:entrySubject.summary.stringValue];

    CGRect frame = _summary.frame;

    frame.size = _summary.contentSize;

    _summary.frame = frame;
    [_summary setFrame:CGRectMake(_summary.frame.origin.x, _summary.frame.origin.y, _summary.bounds.size.width, _summary.contentSize.height)];
    [_container setContentSize:CGSizeMake(_container.contentSize.width, _summary.bounds.size.height + _summary.frame.origin.y)];
}

- (void)requestFinished:(DOUHttpRequest *)aRequest {
    NSLog(@"book details response : %@", aRequest.responseString);

    if (!aRequest.error) {
        entrySubject = [[DoubanEntrySubject alloc] initWithData:aRequest.responseData];


        [_bookTitle setText:entrySubject.title.stringValue];
        [_bookTitle sizeToFit];
        [_author setText:((GDataPerson *) entrySubject.authors.first).name];
        [_author sizeToFit];


        [_publisher setText:entrySubject.publisher];
        [_publishDate setText:entrySubject.publishDate];
        NSURL *imageUrl = entrySubject.imageLink.URL;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [_bookImage setImageWithURLRequest:request placeholderImage:DEFAULT_BOOK_COVER_IMAGE success:^void(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            _bookImage.alpha = 0.0;
            [UIView animateWithDuration:1.0 animations:^(void) {
                _bookImage.alpha = 1.0f;
            }];
        } failure:nil];

        float d = entrySubject.rating.average.floatValue;
        NSString *averageRates = [NSString stringWithFormat:@"%.1f", d];
        if (d == 0) {
            [_rate setText:@"No Rate"];
            [_numberOfRaters setText:nil];
        } else {
            [_rate setText:[NSString stringWithFormat:@"%@", averageRates]];
            [_numberOfRaters setText:[NSString stringWithFormat:@"(%@ raters)", entrySubject.rating.numberOfRaters.stringValue]];
        }

        [self setBookSummaryInfo:entrySubject];

    } else {
        NSLog(@"request.error.description = %@", aRequest.error.description);
    }

}

- (void)requestFailed:(DOUHttpRequest *)aRequest {
    NSLog(@"response failed : %@", aRequest.responseString);
}


- (void)loadView {
    [super loadView];
    [self loadBookDetails];
}

- (void)viewDidUnload {
    [self setBookImage:nil];
    [self setBookTitle:nil];
    [self setBookTitle:nil];
    [self setBookImage:nil];
    [self setBookTitle:nil];
    [self setAuthor:nil];
    [self setPublisher:nil];
    [self setPublishDate:nil];
    [self setRate:nil];
    [self setNumberOfRaters:nil];
    [self setSummary:nil];
    [self setContainer:nil];
    [super viewDidUnload];
}

- (IBAction)addToWish:(id)sender {

}

@end

