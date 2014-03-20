//
//  NumAttribute.m
//  Hunter
//
//  Created by Student on 3/9/14.
//  Copyright 2014 usc. All rights reserved.
//

#import "NumAttribute.h"


@implementation NumAttribute

-(id)init: (int)initVal :(int)lowerVal :(int)upperVal {
    self.cur = initVal;
    self.lowerLimit = lowerVal;
    self.upperLimit = upperVal;
    return self;
}

-(void)add: (int)val {
    self.cur += val;
    [self checkLimit];
}

-(void)setVal: (int)val {
    self.cur = val;
    [self checkLimit];
}

-(void)checkLimit {
    if(self.cur > self.upperLimit)  self.cur = self.upperLimit;
    else if(self.cur < self.lowerLimit) self.cur = self.lowerLimit;
}

@end
