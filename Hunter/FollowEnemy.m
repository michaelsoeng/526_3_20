//
//  Enemy.m
//  SuperKoalio
//
//  Created by Zhe Xie on 2/16/14.
//  Copyright (c) 2014 Interrobang Software LLC. All rights reserved.
//

#import "FollowEnemy.h"
#import "SimpleAudioEngine.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"

@implementation FollowEnemy

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize forwardMarch = _forwardMarch;
@synthesize playerPosition = _playerPosition;

-(id)initWithFile:(NSString *)filename {
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}

- (void) animation:(FollowEnemy*) enemy
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"follow_enemy.plist"];
    
    // Create the actions
    id actionMove1 = [CCRepeatForever actionWithAction:[
                              CCAnimate actionWithSpriteSequence:@"follow_enemy_%d.png"
                                                        numFrames:6
                                                        delay:0.15
                                                        restoreOriginalFrame:NO]];
    [enemy runAction: actionMove1];
}


-(void)followPlayer:(CGPoint)playerPos byitself:(FollowEnemy*)enemy
{
    ccTime actualDuration = 0.5;
    
    CGPoint des;
    des.x = playerPos.x - 60;
    des.y = playerPos.y + 120;
    
    
    // Create the actions
    id actionMove1 = [CCMoveTo actionWithDuration:actualDuration
                                         position:des];
    
    [enemy runAction: actionMove1];
}



/*
// a method to move the enemy 10 pixels toward the player
- (void) animateEnemy:(FollowEnemy*)enemy
{
    // rotate to face the player
    CGPoint diff = ccpSub(self.playerPosition, enemy.position);
    float angleRadians = atanf((float)diff.y / (float)diff.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    if (diff.x < 0) {
        cocosAngle += 180;
    }
    enemy.rotation = cocosAngle;
    ccTime actualDuration = 10;
    
    // Create the actions
    id actionMove = [CCMoveBy actionWithDuration:actualDuration
                                         position:ccpMult(ccpNormalize(ccpSub(self.playerPosition,enemy.position)), 6)];
    
    [enemy runAction: actionMove];
    
} */
@end
