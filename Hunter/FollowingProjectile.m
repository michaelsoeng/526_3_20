//
//  FollowingProjectile.m
//  Hunter
//
//  Created by Student on 3/9/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import "FollowingProjectile.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"
@implementation FollowingProjectile

@synthesize velocity = _velocity;

-(id)initWithFile:(NSString *)filename{
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}

- (void) animation:(FollowingProjectile*) projectile
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fire.plist"];
    
    // Create the actions
    id actionMove1 = [CCRepeatForever actionWithAction:[
                                                        CCAnimate actionWithSpriteSequence:@"fire_%d.png"
                                                        numFrames:7
                                                        delay:0.15
                                                        restoreOriginalFrame:NO]];
    [projectile runAction: actionMove1];
}


@end

