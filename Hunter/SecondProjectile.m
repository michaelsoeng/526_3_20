//
//  SecondProjectile.m
//  Hunter
//
//  Created by Student on 3/9/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import "Secondprojectile.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"
@implementation SecondProjectile

@synthesize velocity = _velocity;

-(id)initWithFile:(NSString *)filename{
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}

- (void) animation:(SecondProjectile*) projectile
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mud_2.plist"];
    
    // Create the actions
    id actionMove1 = [CCRepeatForever actionWithAction:[
                                                        CCAnimate actionWithSpriteSequence:@"mud_2_%d.png"
                                                        numFrames:4
                                                        delay:0.1
                                                        restoreOriginalFrame:NO]];
    [projectile runAction: actionMove1];
}


@end
