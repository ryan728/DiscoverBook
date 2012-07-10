#import "Kiwi.h"
#import "User.h"
#import "DoubanEntryPeople.h"

SPEC_BEGIN(UserSpec)

describe(@"UserSpec", ^{
  it(@"should init User from DoubanEntryPeople", ^{
    NSString *path = [[NSBundle bundleForClass:[User class]] pathForResource:@"people_entry" ofType:@"xml"];
    DoubanEntryPeople *const people = [[DoubanEntryPeople alloc] initWithData:[NSData dataWithContentsOfFile:path]];
    User *const user = [[User alloc] initWithDoubanEntryPeople:people];
    [[user.id should] equal:people.uid.content];
  });
});

SPEC_END
