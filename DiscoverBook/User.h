@class DoubanEntryPeople;

@interface User : NSObject

+ (void)initDefaultUser:(DoubanEntryPeople *)people;

+ (User *)defaultUser;

- (NSString *)id;
@end
