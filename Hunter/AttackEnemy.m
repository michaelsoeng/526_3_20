//
//  AttackEnemy.m
//  Hunter
//
//  Created by Zhe Xie on 2/18/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import "AttackEnemy.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"

@implementation AttackEnemy

@synthesize velocity = _velocity;

-(id)initWithFile:(NSString *)filename{
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}


- (void) animation:(AttackEnemy*) enemy
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"attack_enemy_1.plist"];
    
    // Create the actions
    id actionMove1 = [CCRepeatForever actionWithAction:[
                                                        CCAnimate actionWithSpriteSequence:@"attack_enemy_1_%d.png"
                                                        numFrames:3
                                                        delay:0.7
                                                        restoreOriginalFrame:NO]];
    [enemy runAction: actionMove1];
}

@end
