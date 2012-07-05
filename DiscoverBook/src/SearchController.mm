#import "SearchController.h"
#import "SearchItemView.h"
#include <Box2D/Box2D.h>

#define PTM_RATIO 16

@interface SearchController () {
  NSTimer *tickTimer;
}

@end

@implementation SearchController {
}
@synthesize term = _term;
@synthesize world = world_;
@synthesize groundBody = groundBody_;

#pragma mark - life cycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self createPhysicsWorld];

  [self.view addSubview:[[SearchItemView alloc] initWithText:_term in:self at:CGPointMake(10, 10)]];
  [self.view addSubview:[[SearchItemView alloc] initWithText:_term in:self at:CGPointMake(10, 50)]];
  [self.view addSubview:[[SearchItemView alloc] initWithText:_term in:self at:CGPointMake(30, 20)]];
  [self.view addSubview:[[SearchItemView alloc] initWithText:_term in:self at:CGPointMake(40, 15)]];


  for (UIView *oneView in self.view.subviews) {
    [self addPhysicalBodyForView:oneView];
  }

  tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
  [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60.0)];
  [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  b2Vec2 gravity;
  gravity.Set(acceleration.x * 9.81, acceleration.y * 9.81);

  world_->SetGravity(gravity);
}


- (void)tick:(NSTimer *)timer {
  //It is recommended that a fixed time step is used with Box2D for stability
  //of the simulation, however, we are using a variable time step here.
  //You need to make an informed choice, the following URL is useful
  //http://gafferongames.com/game-physics/fix-your-timestep/

  int32 velocityIterations = 8;
  int32 positionIterations = 1;

  // Instruct the world to perform a single step of simulation. It is
  // generally best to keep the time step and iterations fixed.
  world_->Step(1.0f / 60.0f, velocityIterations, positionIterations);

  //Iterate over the bodies in the physics world
  for (b2Body *b = world_->GetBodyList(); b; b = b->GetNext()) {
    if (b->GetUserData() != NULL) {
      UIView *oneView = (__bridge UIView *) b->GetUserData();

      // y Position subtracted because of flipped coordinate system
      CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO,
              self.view.bounds.size.height - b->GetPosition().y * PTM_RATIO);
      oneView.center = newCenter;

      CGAffineTransform transform = CGAffineTransformMakeRotation(-b->GetAngle());

      oneView.transform = transform;
    }
  }
}

- (void)createPhysicsWorld {
  CGSize screenSize = self.view.bounds.size;

  b2Vec2 gravity;
//  gravity.Set(0, 0);
  gravity.Set(0.0f, -9.81f);

  bool doSleep = false;
  world_ = new b2World(gravity);
  world_->SetAllowSleeping(doSleep);

  world_->SetContinuousPhysics(true);

  b2BodyDef groundBodyDef;
  groundBodyDef.position.Set(0, 0); // bottom-left corner

  // Call the body factory which allocates memory for the ground body
  // from a pool and creates the ground box shape (also from a pool).
  // The body is also added to the world.
  groundBody_ = world_->CreateBody(&groundBodyDef);

  // Define the ground box shape.
  b2EdgeShape groundBox;

  // bottom
  groundBox.Set(b2Vec2(0, 0), b2Vec2(screenSize.width / PTM_RATIO, 0));
  groundBody_->CreateFixture(&groundBox, 0);

  // top
  groundBox.Set(b2Vec2(0, screenSize.height / PTM_RATIO), b2Vec2(screenSize.width / PTM_RATIO, screenSize.height / PTM_RATIO));
  groundBody_->CreateFixture(&groundBox, 0);

  // left
  groundBox.Set(b2Vec2(0, screenSize.height / PTM_RATIO), b2Vec2(0, 0));
  groundBody_->CreateFixture(&groundBox, 0);

  // right
  groundBox.Set(b2Vec2(screenSize.width / PTM_RATIO, screenSize.height / PTM_RATIO), b2Vec2(screenSize.width / PTM_RATIO, 0));
  groundBody_->CreateFixture(&groundBox, 0);
}

  - (void)addPhysicalBodyForView:(UIView *)physicalView {
    // Define the dynamic body.
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;

    CGPoint p = physicalView.center;
    CGPoint boxDimensions = CGPointMake(physicalView.bounds.size.width / PTM_RATIO / 2.0, physicalView.bounds.size.height / PTM_RATIO / 2.0);

    bodyDef.position.Set(p.x / PTM_RATIO, (460.0 - p.y) / PTM_RATIO);
    bodyDef.userData = (__bridge void *) physicalView;

    // Tell the physics world to create the body
    b2Body *body = world_->CreateBody(&bodyDef);

    // Define another box shape for our dynamic body.
    b2PolygonShape dynamicBox;

    dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);

    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;
    fixtureDef.density = 3.0f;
    fixtureDef.friction = 0.3f;
    fixtureDef.restitution = 0.5f; // 0 is a lead ball, 1 is a super bouncy ball
    body->CreateFixture(&fixtureDef);

    // a dynamic body reacts to forces right away
    body->SetType(b2_dynamicBody);

    // we abuse the tag property as pointer to the physical body
    physicalView.tag = (int) body;
  }
@end