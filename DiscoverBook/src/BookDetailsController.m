#import "BookDetailsController.h"
#import "DoubanEntrySubject.h"
#import "AFNetworking.h"
#import "NSArray+Additions.h"
#import "DoubanFeedEvent.h"

@implementation BookDetailsController {
    DoubanEntrySubject *entrySubject;
    NSString *currentStatus;
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
@synthesize wishButton = _wishButton;
@synthesize readingButton = _readingButton;
@synthesize readButton = _readButton;


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

- (void)setBookSummaryInfo {
    [_summary setText:entrySubject.summary.stringValue];

    CGRect frame = _summary.frame;
    frame.size = _summary.contentSize;

    _summary.frame = frame;
    [_summary setFrame:CGRectMake(_summary.frame.origin.x, _summary.frame.origin.y, _summary.bounds.size.width, _summary.contentSize.height)];
    [_container setContentSize:CGSizeMake(_container.contentSize.width, _summary.bounds.size.height + _summary.frame.origin.y)];
}

- (void)setRateInfo {
    float d = entrySubject.rating.average.floatValue;
    NSString *averageRates = [NSString stringWithFormat:@"%.1f", d];
    if (d == 0) {
        [_rate setText:@"No Rate"];
        [_numberOfRaters setText:nil];
    } else {
        [_rate setText:[NSString stringWithFormat:@"%@", averageRates]];
        [_numberOfRaters setText:[NSString stringWithFormat:@"(%@ raters)", entrySubject.rating.numberOfRaters.stringValue]];
    }
}

- (void)setImageInfo {
    _bookImage.clipsToBounds = YES;
    NSLog(@"image %@", _bookImage.image);
    NSLog(@"bounds before  %@", NSStringFromCGRect(_bookImage.bounds));
    NSURL *imageUrl = entrySubject.imageLink.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [_bookImage setImageWithURLRequest:request placeholderImage:DEFAULT_BOOK_COVER_IMAGE success:^void(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        _bookImage.alpha = 0.0;
        [UIView animateWithDuration:1.0 animations:^(void) {
            _bookImage.alpha = 1.0f;
        }];
            NSLog(@"bounds after  %@", NSStringFromCGRect(_bookImage.bounds));
    } failure:nil];
}

- (void)changeButtonStatus {
    [self resetButtonStatus];
    if (currentStatus == @"wish") {
        [_wishButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_wishButton setSelected:YES];
    } else if (currentStatus == @"reading") {
        [_readingButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_readingButton setSelected:YES];
    } else if (currentStatus == @"read") {
        [_readButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_readButton setSelected:YES];
    }
    [[self view] setNeedsDisplay];
}
- (void)resetButtonStatus{
    [_wishButton setSelected:NO];
    [_readingButton setSelected:NO];
    [_readButton setSelected:NO];
}

- (void)updateBookStatus:(DOUHttpRequest *)aRequest completeCallBack:(DOUReqBlock)completeCallBack {
    NSLog(@"bookCollectionUrl = %@", _bookCollectionUrl);

    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:[_bookCollectionUrl substringFromIndex:21] parameters:nil];
    DoubanEntrySubject *subject = [[DoubanEntrySubject alloc] initWithData:aRequest.responseData];
    GDataXMLElement *element = subject.XMLElement;
    [[[element elementsForName:@"db:status"] objectAtIndex:0] setStringValue:currentStatus];

    DoubanEntryEvent *entryBase = [[DoubanEntryEvent alloc] initWithXMLElement:element parent:nil];

    DOUService *service = [DOUService sharedInstance];
    [service put:query object:entryBase callback:completeCallBack];

    NSLog(@"request.responseString = %@", aRequest.responseString);
    NSLog(@"request.responseStatusCode = %d", aRequest.responseStatusCode);
}

- (void)requestFinished:(DOUHttpRequest *)aRequest {
    NSLog(@"book details response : %@", aRequest.responseString);
    if (!aRequest.error) {
        if ([aRequest.url.absoluteString rangeOfString:@"collection"].length == 0) {
            entrySubject = [[DoubanEntrySubject alloc] initWithData:aRequest.responseData];
            [_bookTitle setText:entrySubject.title.stringValue];
            [_bookTitle sizeToFit];
            [_author setText:((GDataPerson *) entrySubject.authors.first).name];
            [_author sizeToFit];
            [_publisher setText:entrySubject.publisher];
            [_publishDate setText:entrySubject.publishDate];
            [self setImageInfo];
            [self setRateInfo];
            [self changeButtonStatus];
            [self setBookSummaryInfo];
        } else {
            DOUReqBlock completeCallBack = ^(DOUHttpRequest *request) {
                if (!request.error) {
                    NSLog(@"request.responseString = %@", request.responseString);
                    NSLog(@"request.responseStatusCode = %d", request.responseStatusCode);
                } else {
                    NSLog(@"request.error.description = %@", request.error.description);
                }

            };

            [self updateBookStatus:aRequest completeCallBack:completeCallBack];
        }

    } else {
        NSLog(@"request.error.description = %@", aRequest.error.description);
    }

}

- (void)requestFailed:(DOUHttpRequest *)aRequest {
    NSLog(@"response failed : %@", aRequest.responseString);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadBookDetails];
}

- (void)requestCollectionEntry {
    NSURL *const url = [[NSURL alloc] initWithString:_bookCollectionUrl];
    DOUHttpRequest *request = [[DOUHttpRequest alloc] initWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)addToStatus:(NSString *)status {
    [self requestCollectionEntry];
    currentStatus = status;
    [self changeButtonStatus];
}

- (IBAction)addToWish:(id)sender {
    [self addToStatus:@"wish"];
}

- (IBAction)addToReading:(id)sender {
    [self addToStatus:@"reading"];
}

- (IBAction)addToRead:(id)sender {
    [self addToStatus:@"read"];}

@end

