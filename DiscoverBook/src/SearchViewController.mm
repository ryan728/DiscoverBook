#import "SearchViewController.h"
#import "CCDirector.h"
#import "SearchViewLayer.h"

@implementation SearchViewController

@synthesize term = _term;

- (void)viewDidLoad {
  [super viewDidLoad];

  CCDirector *director = [CCDirector sharedDirector];
  EAGLView *glView = [EAGLView viewWithFrame:self.view.bounds
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
