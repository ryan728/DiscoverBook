#import "Kiwi.h"

SPEC_BEGIN(MathSpec)

describe(@"MathSpec", ^{
  it(@"should successed", ^{
    int a = 1;
    int b = 2;
    [[theValue(a + b) should] equal:theValue(3)];
  });
});

SPEC_END
