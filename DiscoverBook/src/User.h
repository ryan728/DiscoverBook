@class DoubanEntryPeople;

@interface User : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSURL *imageUrl;

+ (void)initDefaultUser:(DoubanEntryPeople *)people;
+ (User *)defaultUser;
+ (void)clearDefaultUser;
+ (User *)findUserWithTitle:(NSString *)title;

- (id)initWithDoubanEntryPeople:(DoubanEntryPeople *)people;
- (NSArray *) readingBooks;
- (NSArray *) wishBooks;
- (NSArray *) readBooks;
- (NSArray *) contacts;
- (NSArray *) friends;
@end
