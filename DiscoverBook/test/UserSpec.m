#import "Kiwi.h"
#import "User.h"
#import "DoubanEntryPeople.h"

SPEC_BEGIN(UserSpec)

describe(@"UserSpec", ^{

  __block DoubanEntryPeople *people;

  beforeAll(^void() {
    NSString *path = [[NSBundle bundleForClass:[User class]] pathForResource:@"people_entry" ofType:@"xml"];
    people = [[DoubanEntryPeople alloc] initWithData:[NSData dataWithContentsOfFile:path]];
  });

  it(@"should init User from DoubanEntryPeople", ^{
    User *const user = [[User alloc] initWithDoubanEntryPeople:people];
    [[user.id should] equal:@"mechiland"];
    [[user.title should] equal:@"Michael Chen"];
    [[user.signature should] equal:@"压力山大"];
    [[user.imageUrl should] equal:[NSURL URLWithString:@"http://img3.douban.com/icon/u1032321-1.jpg"]];

    [[[User findUserWithTitle:@"Michael Chen"].id should] equal:@"mechiland"];
  });

  it(@"should save default user info", ^{
    [User initDefaultUser:people];
    [[[User defaultUser].id should] equal: @"mechiland"];
    [[[User findUserWithTitle:@"Michael Chen"].id should] equal: @"mechiland"];
    NSUserDefaults *const userDefaults = [NSUserDefaults standardUserDefaults];
    [[[userDefaults objectForKey:@"userId"] should] equal:@"mechiland"];
    [[[userDefaults objectForKey:@"userName"] should] equal:@"Michael Chen"];
  });

  it(@"should clean default user info", ^{
    [User initDefaultUser:people];
    [User clearDefaultUser];
    NSUserDefaults *const userDefaults = [NSUserDefaults standardUserDefaults];
    [[userDefaults objectForKey:@"userId"] shouldBeNil];
    [[userDefaults objectForKey:@"userName"] shouldBeNil];
  });

  it(@"should get default user from NSUserDefault if no default user but has info stored", ^{
    NSUserDefaults *const userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"defaultId" forKey:@"userId"];
    [userDefaults setObject:@"defaultName" forKey:@"userName"];

    User *user = [User defaultUser];
    [[user.id should] equal:@"defaultId"];
    [[user.title should] equal:@"defaultName"];
    [user.signature shouldBeNil];
  });
});

SPEC_END
