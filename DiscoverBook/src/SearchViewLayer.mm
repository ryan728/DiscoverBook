#import "SearchViewLayer.h"
#import "CCScene.h"
#import "CCDirector.h"
#import "CCSpriteBatchNode.h"
#import "CCLabelTTF.h"
#import "CGPointExtension.h"
#import "CCActionInterval.h"


#define PTM_RATIO 32

enum {
  kTagTileMap = 1,
  kTagBatchNode = 1,
  kTagAnimation1 = 1,
};

@implementation SearchViewLayer {
  NSMutableArray *movableSprites_;
  CCSprite *selSprite;
  b2Body *groundBody;
  BOOL hasTouches;
  CGSize screenSize;
}

+ (CCScene *)scene {
  CCScene *scene = [CCScene node];
  SearchViewLayer *layer = [SearchViewLayer node];
  [scene addChild:layer];
  return scene;
}

- (CGSize)initWorld {
  b2Vec2 gravity;
  gravity.Set(0.0f, 0.0f);

  bool doSleep = true;
  world = new b2World(gravity);
  world->SetAllowSleeping(doSleep);
  world->SetContinuousPhysics(true);
  m_debugDraw = new GLESDebugDraw(PTM_RATIO);
  world->SetDebugDraw(m_debugDraw);

  uint32 flags = 0;
  flags += b2DebugDraw::e_shapeBit;
  flags += b2DebugDraw::e_jointBit;
  m_debugDraw->SetFlags(flags);

  b2BodyDef groundBodyDef;
  groundBodyDef.position.Set(0, 0); // bottom-left corner

  groundBody = world->CreateBody(&groundBodyDef);

  b2EdgeShape groundBox;
  groundBox.Set(b2Vec2(0, 0), b2Vec2(screenSize.width / PTM_RATIO, 0));
  groundBody->CreateFixture(&groundBox, 0);

  // top
  groundBox.Set(b2Vec2(0, screenSize.height / PTM_RATIO), b2Vec2(screenSize.width / PTM_RATIO, screenSize.height / PTM_RATIO));
  groundBody->CreateFixture(&groundBox, 0);

  // left
  groundBox.Set(b2Vec2(0, screenSize.height / PTM_RATIO), b2Vec2(0, 0));
  groundBody->CreateFixture(&groundBox, 0);

  // right
  groundBox.Set(b2Vec2(screenSize.width / PTM_RATIO, screenSize.height / PTM_RATIO), b2Vec2(screenSize.width / PTM_RATIO, 0));
  groundBody->CreateFixture(&groundBox, 0);
  return screenSize;
}

- (void)addSprites {
//  CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"default_book_cover.jpg" capacity:150];
//  [self addChild:batch z:0 tag:kTagBatchNode];

  b2Body *body1 = [self addNewSpriteWithCoords:ccp(screenSize.width / 2, screenSize.height / 2)];
  b2Body *body2 = [self addNewSpriteWithCoords:ccp(screenSize.width / 3, screenSize.height / 3)];
  [self join:body1 with:body2];

//    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
//    [self addChild:label z:0];
//    [label setColor:ccc3(0, 0, 255)];
//    label.position = ccp(screenSize.width / 2, screenSize.height - 50);

}

- (id)init {
  self = [super init];
  if (self) {
    movableSprites_ = [[NSMutableArray alloc] init];
    self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;
    hasTouches = NO;
    screenSize = [CCDirector sharedDirector].winSize;

    [self initWorld];
    [self addSprites];
    [self schedule:@selector(tick:)];
  }

  return self;
}

- (void)draw {
  // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
  // Needed states:  GL_VERTEX_ARRAY,
  // Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
  glDisable(GL_TEXTURE_2D);
  glDisableClientState(GL_COLOR_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glEnable(GL_LINE_SMOOTH);
  glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glLineWidth(1);

  world->DrawDebugData();

  // restore default GL states
  glEnable(GL_TEXTURE_2D);
  glEnableClientState(GL_COLOR_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

- (void)join:(b2Body *)body1 with:(b2Body *)body2 {
  const float32 length = (body1->GetPosition() - body2->GetPosition()).Length();

  b2DistanceJointDef distJDef;
  b2Vec2 anchor1 = body1->GetWorldCenter();
  b2Vec2 anchor2 = body2->GetWorldCenter();
  distJDef.Initialize(body1, body2, anchor1, anchor2);
  distJDef.collideConnected = false;
  distJDef.dampingRatio = 0.9f;
  distJDef.frequencyHz = 3;
  distJDef.length = length * 1.5;
  world->CreateJoint(&distJDef);

  b2RopeJointDef rDef;
  rDef.maxLength = length * 2.5;
  rDef.localAnchorA = rDef.localAnchorB = b2Vec2_zero;
  rDef.bodyA = body2;
  rDef.bodyB = body1;
  world->CreateJoint(&rDef);
}

- (b2Body *)addNewSpriteWithCoords:(CGPoint)p {
  CCLOG(@"Add sprite %0.2f x %02.f", p.x, p.y);
//  CCSpriteBatchNode *batch = (CCSpriteBatchNode *) [self getChildByTag:kTagBatchNode];

  //We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
  //just randomly picking one of the images
  int idx = (CCRANDOM_0_1() > .5 ? 0 : 1);
  int idy = (CCRANDOM_0_1() > .5 ? 0 : 1);

  const CGRect rect = CGRectMake(32 * idx, 32 * idy, 32, 32);
//  CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:rect];
  CCSprite *sprite = [CCSprite spriteWithFile:@"default_book_cover.jpg" rect:rect];
  CCSprite *bg = [CCSprite spriteWithFile:@"round_corner_bg.png"];
  [sprite addChild:bg z:1];

  [movableSprites_ addObject:sprite];
  sprite.position = ccp(p.x, p.y);
  [self addChild:sprite];
  const CGSize bgSize = bg.boundingBox.size;
  bg.position = CGPointMake(bgSize.width / 2, bgSize.height / 2);

  // Define the dynamic body.
  //Set up a 1m squared box in the physics world
  b2BodyDef bodyDef;
  bodyDef.type = b2_dynamicBody;

  bodyDef.position.Set(p.x / PTM_RATIO, p.y / PTM_RATIO);
  bodyDef.userData = sprite;
  b2Body *body = world->CreateBody(&bodyDef);

  // Define another box shape for our dynamic body.
  b2PolygonShape dynamicBox;
  dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box

  // Define the dynamic body fixture.
  b2FixtureDef fixtureDef;
  fixtureDef.shape = &dynamicBox;
  fixtureDef.density = 1.0f;
  fixtureDef.friction = 0.3f;
  fixtureDef.restitution = 0.0f;
  body->CreateFixture(&fixtureDef);
  body->SetLinearDamping(600.0f);

  return body;
}

- (void)fireLongPress:(CCSprite *)sprite {
  id action = [CCSequence actions:[CCScaleTo actionWithDuration:0.3f scale:2.0f],
  [CCScaleTo actionWithDuration:0.3f scale:1.0f], nil];
  CCRepeat *repeatAction = [CCRepeat actionWithAction:action times:5];
  [[sprite.children objectAtIndex:0] runAction:repeatAction];
}

- (void)tick:(ccTime)dt {
  //It is recommended that a fixed time step is used with Box2D for stability
  //of the simulation, however, we are using a variable time step here.
  //You need to make an informed choice, the following URL is useful
  //http://gafferongames.com/game-physics/fix-your-timestep/

  int32 velocityIterations = 8;
  int32 positionIterations = 1;

  // Instruct the world to perform a single step of simulation. It is
  // generally best to keep the time step and iterations fixed.
  world->Step(dt, velocityIterations, positionIterations);


  //Iterate over the bodies in the physics world
  for (b2Body *b = world->GetBodyList(); b; b = b->GetNext()) {
    if (b->GetUserData() != NULL) {
      //Synchronize the AtlasSprites position and rotation with the corresponding body
      CCSprite *myActor = (CCSprite *) b->GetUserData();
      if (myActor == selSprite && hasTouches) {
        b->SetTransform(b2Vec2(myActor.position.x / PTM_RATIO, myActor.position.y / PTM_RATIO), 0);
        b->SetActive(true);
      } else {
        myActor.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
        myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
      }
//      id action = [CCMoveTo actionWithDuration:0.4 position:CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO)];
//      [sprite runAction:action];
    }
  }
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
  CCSprite *newSprite = nil;
  for (CCSprite *sprite in movableSprites_) {
    if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
      newSprite = sprite;
      break;
    }
  }
  if (newSprite != selSprite) {
    selSprite = newSprite;
  }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint touchLocation = [self convertTouchToNodeSpace:[touches anyObject]];
  [self selectSpriteForTouch:touchLocation];
  [self performSelector:@selector(fireLongPress:)
             withObject:selSprite afterDelay:1.0f];
  hasTouches = YES;
  NSLog(@"---------------- start position) = %@", NSStringFromCGPoint(selSprite.position));
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  CGPoint retval = newPos;
  retval.x = MIN(retval.x, 0);
  retval.x = MAX(retval.x, winSize.width);
  retval.y = self.position.y;
  return retval;
}

- (BOOL)spriteOutOfBound:(CGPoint)point {
  const CGSize spriteSize = selSprite.boundingBox.size;
  const CGSize winSize = [CCDirector sharedDirector].winSize;
  if (point.y + spriteSize.height / 2 > winSize.height) {
    return YES;
  }
  if (point.y - spriteSize.height / 2 < 0) {
    return YES;
  }
  if (point.x + spriteSize.width / 2 > winSize.width) {
    return YES;
  }
  if (point.x - spriteSize.width / 2 < 0) {
    return YES;
  }
  return NO;
}

- (void)panForTranslation:(CGPoint)translation {
  if (selSprite) {
    CGPoint newPos = ccpAdd(selSprite.position, translation);

    if ([self spriteOutOfBound:newPos]) {
      return;
    }
    selSprite.position = newPos;
  }
  //  else {
  //    CGPoint newPos = ccpAdd(self.position, translation);
  //    self.position = [self boundLayerPos:newPos];
  //  }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fireLongPress:) object:selSprite];
  UITouch *touch = [touches anyObject];
  CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

  CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
  oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
  oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];

  CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
  [self panForTranslation:translation];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  //  Add a new body/atlas sprite at the touched location
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fireLongPress:) object:selSprite];
  NSLog(@"---------------- end position) = %@", NSStringFromCGPoint(selSprite.position));
  hasTouches = NO;
  //  for (UITouch *touch in touches) {
  //    CGPoint location = [touch locationInView:[touch view]];
  //
  //    location = [[CCDirector sharedDirector] convertToGL:location];
  //
  //    [self addNewSpriteWithCoords:location];
  //  }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  static float prevX = 0, prevY = 0;

  //#define kFilterFactor 0.05f
#define kFilterFactor 1.0f  // don't use filter. the code is here just as an example

  float accelX = (float) acceleration.x * kFilterFactor + (1 - kFilterFactor) * prevX;
  float accelY = (float) acceleration.y * kFilterFactor + (1 - kFilterFactor) * prevY;

  prevX = accelX;
  prevY = accelY;

  // accelerometer values are in "Portrait" mode. Change them to Landscape left
  // multiply the gravity by 10
  b2Vec2 gravity(-accelY * 10, accelX * 10);

  world->SetGravity(gravity);
}


@end
