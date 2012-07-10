#import "MyContactController.h"
#import "User.h"
#import "DOUQuery.h"
#import "DOUService.h"
#import "DoubanFeedSubject.h"
#import "DoubanFeedPeople.h"
#import "Macros.h"
#import "TWImageView+Additions.h"
#import "NSArray+Additions.h"

@implementation MyContactController

static UIImage *DEFAULT_CONTACT_ICON = nil;

+ (void)initialize {
  NSString *defaultBookCoverPath = [[NSBundle mainBundle] pathForResource:@"default_contact" ofType:@"png"];
  DEFAULT_CONTACT_ICON = [UIImage imageWithContentsOfFile:defaultBookCoverPath];
}

- (DOUQuery *)createQuery:(int)startIndex {
  User *user = [User findUserWithTitle:self.userTitle];
  NSDictionary *const parameters = [NSDictionary dictionaryWithObjects:Array([NSString stringWithFormat:@"%u", RESULT_BATCH_SIZE], [NSString stringWithFormat:@"%u", startIndex]) forKeys:Array(@"max-results", @"start-index")];
  return [[DOUQuery alloc] initWithSubPath:[NSString stringWithFormat:@"/people/%@/%@", user.id, self.title.lowercaseString] parameters:parameters];
}

- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath {
  User *user = [self.myEntries objectAtIndex:indexPath.row];
  cell.textLabel.text = user.title;
  cell.detailTextLabel.text = user.signature;
  [cell.imageView setImageWithAnimation:user.imageUrl andPlaceHolder:DEFAULT_CONTACT_ICON];
}

- (NSArray *)parseResult:(DOUHttpRequest *)request {
  DoubanFeedPeople *const feedSubject = [[DoubanFeedPeople alloc] initWithData:request.responseData];
  NSMutableArray *results = [[NSMutableArray alloc] init];

  [feedSubject.entries each:^void(DoubanEntryPeople *people) {
    [results addObject:[[User alloc] initWithDoubanEntryPeople:people]];
  }];
  return results;
}

- (void)jumpHome {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  if (indexPath.row != self.myEntries.count) {
    self.tabBarController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.userTitle style:UIBarButtonItemStylePlain target:nil action:nil];
    [self performSegueWithIdentifier:@"peopleDetail" sender:self];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UITabBarController *tabBarController = segue.destinationViewController;
  NSArray *const viewControllers = tabBarController.viewControllers;
  [viewControllers eachWithIndex:^(MyTableViewController *controller, NSUInteger i) {
    User *user = [self.myEntries objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    controller.userTitle = user.title;
    if (i != viewControllers.count - 1) {
      tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(jumpHome)];
      [controller loadData];
    } else {
      UITabBarItem *item = [tabBarController.tabBar.items objectAtIndex:i];
      item.enabled = NO;
    }
  }];
  [super prepareForSegue:segue sender:sender];
}

@end
