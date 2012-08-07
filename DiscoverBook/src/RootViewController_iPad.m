#import "RootViewController_iPad.h"
#import "GlobalConfig.h"
#import "WheelViewCell.h"

@interface RootViewController_iPad ()

@property(nonatomic, strong) NSMutableArray *cells;

@end

@implementation RootViewController_iPad

@synthesize cells = _cells;

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    self.cells = [NSMutableArray arrayWithCapacity:kCellCount];
    UIImage *defaultImage = [UIImage imageNamed:@"default_book_cover.jpg"];
    for (NSUInteger index = 0; index < kCellCount; index++) {
      WheelViewCell *cell = [[WheelViewCell alloc] initWithImage:defaultImage];
      [self.cells addObject:cell];
    }
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma - WheelViewDataSource

-(NSInteger)wheelViewNumberOfCells:(WheelView *)wheelView {
  return kCellCount;
}

-(WheelViewCell *)wheelView:(WheelView *)wheelView cellAtIndex:(NSInteger)index {
  return [self.cells objectAtIndex:index];
}


@end
