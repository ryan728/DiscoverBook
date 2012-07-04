@class DoubanEntryPeople;

@interface User : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSURL *imageUrl;

+ (void)initDefaultUser:(DoubanEntryPeople *)people;
+ (User *)defaultUser;
+ (void)clearDefaultUser;

- (id)initWithDoubanEntryPeople:(DoubanEntryPeople *)people;
@end
