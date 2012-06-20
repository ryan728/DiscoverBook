#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue outterGlue:(NSString *)outterGlue {
  NSArray *firstExplode = [self componentsSeparatedByString:outterGlue];

  NSInteger count = [firstExplode count];
  NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
  for (NSInteger i = 0; i < count; i++) {
    NSArray *secondExplode = [(NSString *) [firstExplode objectAtIndex:i] componentsSeparatedByString:innerGlue];
    if ([secondExplode count] == 2) {
      [returnDictionary setObject:[secondExplode objectAtIndex:1] forKey:[secondExplode objectAtIndex:0]];
    }
  }
  return returnDictionary;
}
@end
