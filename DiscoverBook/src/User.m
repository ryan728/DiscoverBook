#import "User.h"
#import "DoubanEntryPeople.h"

@interface User ()

@property(nonatomic, strong) DoubanEntryPeople *doubanEntryPeople;

@end

@implementation User
@synthesize doubanEntryPeople = _doubanEntryPeople;
@synthesize id = id_;
@synthesize title = title_;


- (id)initWithDoubanEntryPeople:(DoubanEntryPeople *)people; {
  if ((self = [super init])) {
    id_ = people.uid.content;
    title_ = people.title.stringValue;
  }

  [User saveDefaultUserWithId:id_ andName:title_];
  return self;
}

#pragma mark - Class
static User *defaultUser = nil;

+ (void)saveDefaultUserWithId:(NSString *)id andName:(NSString *)name {
  NSUserDefaults *const userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:id forKey:@"userId"];
  [userDefaults setObject:name forKey:@"userName"];
  [userDefaults synchronize];
}

+ (void)clearDefaultUser {
  [User saveDefaultUserWithId:nil andName:nil];
}


+ (void)initDefaultUser:(DoubanEntryPeople *)people {
  if (!defaultUser) {
    defaultUser = [[User alloc] initWithDoubanEntryPeople:people];
  }
}

+ (User *)defaultUser {
  if (defaultUser == nil) {
    NSUserDefaults *const userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userId"];
    NSString *userName = [userDefaults objectForKey:@"userName"];

    if (userId && userName) {
      defaultUser = [[self alloc] init];
      defaultUser.id = userId;
      defaultUser.title = userName;
    }
  }
  return defaultUser;
}

@end
