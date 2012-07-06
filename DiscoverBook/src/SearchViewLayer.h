#import "CCLayer.h"
#import "GLES-Render.h"

@class CCScene;

@interface SearchViewLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
}

+(CCScene *) scene;
-(b2Body *) addNewSpriteWithCoords:(CGPoint)p;
@end
