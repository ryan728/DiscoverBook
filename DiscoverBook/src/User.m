#import "User.h"
#import "DoubanEntryPeople.h"

@interface User ()

@property(nonatomic, strong) DoubanEntryPeople *doubanEntryPeople;

@end

@implementation User
@synthesize doubanEntryPeople = _doubanEntryPeople;


- (id)initWithDoubanEntryPeople:(DoubanEntryPeople *)people; {
  if ((self = [super init])) {
    self.doubanEntryPeople = people;
  }

  return self;
}

#pragma mark - Class

// your classes methods here


#pragma mark - NSObject Methods

// your base class overrides here


static User* defaultUser = nil;

+ (void)initDefaultUser:(DoubanEntryPeople *)people {
  if (!defaultUser) {
    defaultUser = [[User alloc] initWithDoubanEntryPeople:people];
  }
}

+ (User *)defaultUser {
 return defaultUser;
}

- (NSString *)id {
  return _doubanEntryPeople.uid.content;
}

@end
