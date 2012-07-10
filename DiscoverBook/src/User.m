#import "User.h"
#import "DoubanEntryPeople.h"

@interface User ()

@property(nonatomic, strong) DoubanEntryPeople *doubanEntryPeople;

@end

@implementation User {
  NSMutableArray *readingBooks_;
  NSMutableArray *wishBooks_;
  NSMutableArray *readBooks_;
  NSMutableArray *contacts_;
  NSMutableArray *friends_;
}

static NSMutableDictionary *USERS;
static NSString *DEFAULT_USER_TITLE;

+ (void)initialize {
  USERS = [[NSMutableDictionary alloc] init];
}

@synthesize doubanEntryPeople = _doubanEntryPeople;
@synthesize id = id_;
@synthesize title = title_;
@synthesize signature = signature_;
@synthesize imageUrl = imageUrl_;

- (id)initWithDoubanEntryPeople:(DoubanEntryPeople *)people {
  if ((self = [super init])) {
    id_ = people.uid.content;
    title_ = people.title.stringValue;
    signature_ = people.signature.content;
    imageUrl_ = [[people linkWithRelAttributeValue:@"icon"] URL];
    [USERS setObject:self forKey:title_];
  }
  return self;
}

#pragma mark - Class

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
  User *user = [[User alloc] initWithDoubanEntryPeople:people];
  DEFAULT_USER_TITLE = user.title;
  [USERS setObject:user forKey:user.title];
  [User saveDefaultUserWithId:user.id andName:user.title];
}

+ (User *)findUserWithTitle:(NSString *)title {
  if (!title) {
    return [self defaultUser];
  }
  return [USERS objectForKey:title];
}


+ (User *)defaultUser {
  User *defaultUser = [USERS objectForKey:DEFAULT_USER_TITLE];
  if (defaultUser == nil) {
    NSUserDefaults *const userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userId"];
    NSString *userName = [userDefaults objectForKey:@"userName"];

    if (userId && userName) {
      defaultUser = [[self alloc] init];
      defaultUser.id = userId;
      defaultUser.title = userName;
      [USERS setObject:defaultUser forKey:defaultUser.title];
    }
  }
  return defaultUser;
}

- (NSArray *)readingBooks {
  return readingBooks_;
}

- (NSArray *)wishBooks {
  return wishBooks_;
}

- (NSArray *)readBooks {
  return readBooks_;
}

- (NSArray *)contacts {
  return contacts_;
}

- (NSArray *)friends {
  return friends_;
}

@end
