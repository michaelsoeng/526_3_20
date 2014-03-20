//
//  SlowPlayer.m
//  Hunter
//
//  Created by Zhe Xie on 3/10/14.
//  Copyright (c) 2014 usc. All rights reserved.
//
#import "SlowPlayer.h"
#import "SimpleAudioEngine.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"

@implementation SlowPlayer

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;
@synthesize forwardMarch = _forwardMarch, mightAsWellJump = _mightAsWellJump;

-(id)initWithFile:(NSString *)filename {
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}

// set delay half of player
- (void) slowPlayerInitAnimation:(SlowPlayer*) p
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_normal_run.plist"];
    // cannot run when I put it in initWithFile
    self.slowRunAnimation = [CCRepeatForever actionWithAction:[
                                                                 CCAnimate actionWithSpriteSequence:@"player_normal_run_%d.png"
                                                                 numFrames:4
                                                                 delay:0.4
                                                                 restoreOriginalFrame:NO]];
}


-(void)update:(ccTime)dt {
    // slow jump animation
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_normal_jump.plist"];
    if(self.mightAsWellJump){
        id actionMove1 = [
                          CCAnimate actionWithSpriteSequence:@"player_normal_jump_%d.png"
                          numFrames:1
                          delay:0.2
                          restoreOriginalFrame:NO];
        [self runAction: actionMove1];
    }
}

@end
