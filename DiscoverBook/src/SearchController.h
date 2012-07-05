#include <Box2D/Box2D.h>

@interface SearchController : UIViewController <UIAccelerometerDelegate>

@property(nonatomic, assign) b2World *world;
@property(nonatomic, assign) b2Body *groundBody;
@property(nonatomic, copy) NSString *term;
@end