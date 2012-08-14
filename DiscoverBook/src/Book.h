@class DoubanEntrySubject;

@interface Book : NSObject

@property(nonatomic, strong) NSString *isbn;
@property(nonatomic, strong) NSURL *imageUrl;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *authorsString;

- (Book *)initWithEntry:(DoubanEntrySubject *)subject;
@end
