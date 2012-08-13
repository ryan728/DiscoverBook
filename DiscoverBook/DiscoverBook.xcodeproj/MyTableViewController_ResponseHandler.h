#import <Foundation/Foundation.h>
#import "MyTableViewController.h"

@interface MyTableViewController(MyTableViewController_ResponseHandler)

- (void)handleListResponse:(int)startIndex request:(DOUHttpRequest *)request;

@end