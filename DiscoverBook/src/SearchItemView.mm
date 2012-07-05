#import "SearchItemView.h"
#import "SearchController.h"
#include <Box2D/Box2D.h>

#define PTM_RATIO 16

@implementation SearchItemView {
  CGPoint currentPoint;
  __weak SearchController *searchController_;
  b2Body *body;
  b2MouseJoint *mouseJoint;
}

- (UIView *)initWithText:(NSString *)text in:(SearchController *)searchController at:(CGPoint)center {
  self = [super initWithFrame:CGRectMake(0, 0, 50, 50)];
  if (self) {
    self.center = center;
    searchController_ = searchController;
    UILabel *const label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.text = text;
    label.backgroundColor = [UIColor greenColor];
    [self addSubview:label];

    [self addPhysicalBodyForSelf];
  }

  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  b2MouseJointDef md;
  md.bodyA = searchController_.groundBody;
  md.bodyB = body;
  //  md.target = p;
  md.maxForce = 100.0f * body->GetMass();
  mouseJoint = (b2MouseJoint *) searchController_.world->CreateJoint(&md);
  body->SetAwake(true);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint activePoint = [[touches anyObject] locationInView:self];

  CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - currentPoint.x),
          self.center.y + (activePoint.y - currentPoint.y));

  mouseJoint->SetTarget(b2Vec2::b2Vec2(newPoint.x, newPoint.y));
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  searchController_.world->DestroyJoint(mouseJoint);
  mouseJoint = nil;
}

- (void)addPhysicalBodyForSelf {
    // Define the dynamic body.
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;

    CGPoint p = self.center;
    CGPoint boxDimensions = CGPointMake(self.bounds.size.width / PTM_RATIO / 2.0, self.bounds.size.height / PTM_RATIO / 2.0);

    bodyDef.position.Set(p.x / PTM_RATIO, (460.0 - p.y) / PTM_RATIO);
    bodyDef.userData = (__bridge void *) self;

    // Tell the physics world to create the body
    body = searchController_.world->CreateBody(&bodyDef);

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
    self.tag = (int) body;
  }
@end
