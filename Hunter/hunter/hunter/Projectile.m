//
//  Projectile.m
//  Hunter
//
//  Created by Zhe Xie on 2/18/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import "Projectile.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"
@implementation Projectile

@synthesize velocity = _velocity;

-(id)initWithFile:(NSString *)filename{
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}


@end
