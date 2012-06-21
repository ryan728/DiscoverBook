//
//  ReadingBookController.m
//  DiscoverBook
//
//  Created by Lei Zhang on 6/21/12.
//  Copyright 2012 ThoughtWorks. All rights reserved.
//

#import "ReadingBookController.h"
#import "DOUQuery.h"
#import "DOUAPIEngine.h"
#import "DoubanEntryPeople.h"
#import "DoubanFeedSubject.h"
#import "NSArray+Additions.h"
#import "Macros.h"

@interface ReadingBookController ()

@property(nonatomic, assign) DoubanEntryPeople *me;
@property(nonatomic, assign) NSArray *readingBooks;

@end

@implementation ReadingBookController

#pragma mark - Properties
@synthesize me = me_;
@synthesize readingBooks = readingBooks_;

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
}

- (void)viewDidLoad; {
  [super viewDidLoad];

  self.clearsSelectionOnViewWillAppear = NO;

  DOUQuery *query = [[DOUQuery alloc] initWithSubPath:@"/people/@me" parameters:nil];

  DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {
    NSLog(@"response : %@", request.responseString);
    if (!request.error) {
      DoubanEntryPeople *people = [[DoubanEntryPeople alloc] initWithData:request.responseData];
      NSLog(@"title : %@", people.title.stringValue);
      [self getReadingBooks:people];
    } else {
      NSLog(@"request.error.description = %@", request.error.description);
    }
  };
  DOUService *service = [DOUService sharedInstance];
  [service get:query callback:completionBlock];

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)getReadingBooks:(DoubanEntryPeople *)people {
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array(@"book", @"reading") forKeys:Array(@"cat", @"status")];
  DOUQuery *const bookQuery = [[DOUQuery alloc] initWithSubPath:[NSString stringWithFormat:@"/people/%@/collection", people.uid.content] parameters:parameters];

  DOUService *service = [DOUService sharedInstance];
  DOUReqBlock completionBlock = ^(DOUHttpRequest *request) {
    NSLog(@"response : %@", request.responseString);

    if (!request.error) {
      DoubanFeedSubject *const feedSubject = [[DoubanFeedSubject alloc] initWithData:request.responseData];
      NSArray *const entries = feedSubject.entries;
      readingBooks_ = [NSArray arrayWithArray:entries];

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
  if (!readingBooks_) {
    return 0;
  }
  return readingBooks_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
  static NSString *CellIdentifier = @"READING_BOOK_ITEM";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    DoubanEntrySubject *book = [readingBooks_ objectAtIndex:indexPath.row];
    DoubanEntrySubject *subject = [[DoubanEntrySubject alloc] initWithXMLElement:[[[book XMLElement] elementsForName:@"db:subject"] objectAtIndex:0] parent:nil];
    cell.textLabel.text = subject.title.stringValue;
    NSURL *const imageUrl = [[subject linkWithRelAttributeValue:@"image"] URL];
    NSData *const imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *const image = [UIImage imageWithData:imageData];
    [cell.imageView setImage:image];
    NSMutableString *authors = [NSMutableString string];
    [subject.authors each:^(GDataAtomAuthor *author) {
      [authors appendString:author.name];
    }];
    cell.detailTextLabel.text = authors;
  }
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  // 
  // <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
  // // ...
  // // Pass the selected object to the new view controller.
  // [self.navigationController pushViewController:detailViewController animated:YES];
  // [detailViewController release];
  // 
}

@end
