#import "DOUOAuthStore+Additions.h"

@implementation DOUOAuthStore (Additions)

-(BOOL) hasValidAccessToken {
  return self.accessToken != nil && !self.hasExpired;
}
@end
