#import "SearchViewController.h"
#import "CCDirector.h"
#import "SearchViewLayer.h"

@implementation SearchViewController

@synthesize term = _term;

- (void)viewDidLoad {
  [super viewDidLoad];

  CCDirector *director = [CCDirector sharedDirector];
  const CGPoint origin = self.view.bounds.origin;
  const CGSize navigationBarSize = self.navigationController.navigationBar.bounds.size;
  const CGSize viewSize = self.view.bounds.size;
  const CGRect glViewBounds = CGRectMake(origin.x, origin.y + navigationBarSize.height, viewSize.width, viewSize.height - navigationBarSize.height);
  EAGLView *glView = [EAGLView viewWithFrame:glViewBounds
                                 pixelFormat:kEAGLColorFormatRGB565
                                 depthFormat:0];
  [director setOpenGLView:glView];
  [director setAnimationInterval:1.0 / 60];
  [director setDisplayFPS:YES];
  self.view = glView;

  [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
  [[CCDirector sharedDirector] runWithScene:[SearchViewLayer scene]];
}

@end
