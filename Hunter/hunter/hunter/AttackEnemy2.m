//
//  AttackEnemy2.m
//  Hunter
//
//  Created by Student on 3/9/14.
//  Copyright (c) 2014 usc. All rights reserved.
//


#import "AttackEnemy2.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"

@implementation AttackEnemy2

@synthesize velocity = _velocity;

-(id)initWithFile:(NSString *)filename{
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}


- (void) animation:(AttackEnemy2*) enemy
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"attack_enemy_2.plist"];
    
    // Create the actions
    id actionMove1 = [CCRepeatForever actionWithAction:[
                                                        CCAnimate actionWithSpriteSequence:@"attack_enemy_2_%d.png"
                                                        numFrames:7
                                                        delay:0.7
                                                        restoreOriginalFrame:NO]];
    [enemy runAction: actionMove1];
}

@end
