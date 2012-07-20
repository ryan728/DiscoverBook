@class DoubanEntrySubject;

@interface Book : NSObject

@property(nonatomic, strong) NSString *isbn;
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *title;

- (Book *)initWithEntry:(DoubanEntrySubject *)subject;
@end
