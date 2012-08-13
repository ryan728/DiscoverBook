#import "MyContactController.h"
#import "User.h"
#import "TWImageView+Additions.h"
#import "NSArray+Additions.h"
#import "ContactSearchHandler.h"

@implementation MyContactController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.searchHandler = [[ContactSearchHandler alloc]init];
  }
  return self;
}

- (void)renderCell:(UITableViewCell *)cell at:(NSIndexPath *)indexPath {
  User *user = [self.myEntries objectAtIndex:indexPath.row];
  cell.textLabel.text = user.title;
  cell.detailTextLabel.text = user.signature;
  [cell.imageView setImageWithAnimation:user.imageUrl andPlaceHolder:DEFAULT_CONTACT_ICON];
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
  NSMutableArray *const viewControllers = [NSMutableArray arrayWithArray:tabBarController.viewControllers];
  [viewControllers removeLastObject];
  tabBarController.viewControllers = viewControllers;
  [viewControllers eachWithIndex:^(MyTableViewController *controller, NSUInteger i) {
    User *user = [self.myEntries objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    controller.userTitle = user.title;
    tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(jumpHome)];
    [controller loadData];
  }];
  [super prepareForSegue:segue sender:sender];
}

@end
