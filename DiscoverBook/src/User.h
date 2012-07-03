@class DoubanEntryPeople;

@interface User : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;

+ (void)initDefaultUser:(DoubanEntryPeople *)people;
+ (User *)defaultUser;

+ (void)clearDefaultUser;
@end
