#import <QuartzCore/QuartzCore.h>
#import "DOUQuery.h"
#import "DOUAPIEngine.h"
#import "DoubanEntryPeople.h"
#import "DoubanFeedSubject.h"
#import "NSArray+Additions.h"
#import "Macros.h"
#import "User.h"
#import "MyBookController.h"

@interface MyBookController ()

@property(nonatomic, assign) DoubanEntryPeople *me;
@property(nonatomic, strong) NSMutableArray *readingBooks;

@end

@implementation MyBookController

#pragma mark - Properties
@synthesize me = me_;
@synthesize readingBooks = readingBooks_;

#pragma mark - View lifecycle

- (void)viewDidLoad; {
  [super viewDidLoad];

  self.clearsSelectionOnViewWillAppear = NO;
  readingBooks_ = [[NSMutableArray alloc] init];
  if ([User defaultUser]) {
    [self initReadingList];
  } else {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initReadingList) name:@"UserInfoFetched" object:nil];
  }
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initReadingList {
  User *user = [User defaultUser];
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array(@"book", self.title, @"20") forKeys:Array(@"cat", @"status", @"max-results")];
  DOUQuery *const bookQuery = [[DOUQuery alloc] initWithSubPath:[NSString stringWithFormat:@"/people/%@/collection", user.id] parameters:parameters];

  DOUService *service = [DOUService sharedInstance];

  DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {
//    NSLog(@"response : %@", request.responseString);

    if (!request.error) {
      DoubanFeedSubject *const feedSubject = [[DoubanFeedSubject alloc] initWithData:request.responseData];
      NSArray *const entries = feedSubject.entries;

      [entries each:^(DoubanEntrySubject *entry) {
        DoubanEntrySubject *subject = [[DoubanEntrySubject alloc] initWithXMLElement:[[[entry XMLElement] elementsForName:@"db:subject"] objectAtIndex:0] parent:nil];
        [readingBooks_ addObject:subject];
      }];

      [[self tableView] reloadData];
      [[self tableView] layoutIfNeeded];
    } else {
      NSLog(@"request.error.description = %@", request.error.description);
    }
  };
  [service get:bookQuery callback:completionBlock];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
  return readingBooks_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
  static NSString *CellIdentifier = @"READING_BOOK_ITEM";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    DoubanEntrySubject *book = [readingBooks_ objectAtIndex:indexPath.row];
    cell.textLabel.text = book.title.stringValue;

    NSString *defaultBookCover = [[NSBundle mainBundle] pathForResource:@"default_book_cover" ofType:@"jpg"];
    [cell.imageView setImage:[UIImage imageWithContentsOfFile:defaultBookCover]];
    NSURL *const imageUrl = [[book linkWithRelAttributeValue:@"image"] URL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
      NSData *const imageData = [NSData dataWithContentsOfURL:imageUrl];
      UIImage *const image = [UIImage imageWithData:imageData];
      dispatch_async(dispatch_get_main_queue(), ^(void) {
        cell.imageView.alpha = 0.0;
        [cell.imageView setImage:image];

        [UIView animateWithDuration:1.0 animations:^(void){
          cell.imageView.alpha = 1.0f;
        }];
      });
    });

    NSMutableString *authors = [NSMutableString string];
    [book.authors each:^(GDataAtomAuthor *author) {
      [authors appendString:author.name];
    }];
    cell.detailTextLabel.text = authors;
  }
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end