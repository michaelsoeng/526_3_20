//
//  Player.m
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.
//  Copyright 2012 Interrobang Software LLC. All rights reserved.
//

#import "Player.h"
#import "SimpleAudioEngine.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"
#import "Foundation/NSHashTable.h"

@implementation Player

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;
@synthesize forwardMarch = _forwardMarch, mightAsWellJump = _mightAsWellJump;

-(id)initWithFile:(NSString *)filename {
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    
    self.speedStatus = 0;
    self.beginAccTime = -1;
    self.beginDecTime = -1;
    self.beginMagTime = -1;
    
    self.HP = [[NumAttribute alloc] init: 10 : 0 : 10];
    self.Coin = [[NumAttribute alloc] init: 0 : 0: 999999999];
    self.Energy = [[NumAttribute alloc] init: 0 : 0 : 5];
    
    self.hasMagnet = NO;
    
    //self.lastProjectile = nil;
    //self.lastCoin = nil;
    
    self.lastObjects = [[NSHashTable alloc] initWithOptions: 0 capacity: 1000];
    self.nextClearTableTime = 0;
    
    return self;
}



- (void) playerInitAnimation:(Player*) p
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_normal_run.plist"];
    // cannot run when I put it in initWithFile
    self.normalRunAnimation = [CCRepeatForever actionWithAction:[
                                                              CCAnimate actionWithSpriteSequence:@"player_normal_run_%d.png"
                                                              numFrames:4
                                                              delay:0.1
                                                              restoreOriginalFrame:NO]];
}

-(void)update:(ccTime)dt {
    CGPoint jumpForce = ccp(0.0, 900.0);
    float jumpCutoff = 150.0;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_normal_jump.plist"];
    // normal jump animation
    if(self.mightAsWellJump){
        id actionMove1 = [
                          CCAnimate actionWithSpriteSequence:@"player_normal_jump_%d.png"
                          numFrames:1
                          delay:0.1
                          restoreOriginalFrame:NO];
        [self runAction: actionMove1];
    }
    
    if (self.mightAsWellJump && self.onGround) {
        self.velocity = ccpAdd(self.velocity, jumpForce);
        //[[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
    }
    else if (!self.mightAsWellJump && self.velocity.y > jumpCutoff) {
        self.velocity = ccp(self.velocity.x, jumpCutoff);
    }
    
    // changed
    CGPoint gravity = ccp(0.0, -900.0);
    CGPoint gravityStep = ccpMult(gravity, dt);
    CGPoint forwardMove;
    
    forwardMove = ccp(200.0, 0.0);
    
    
    CGPoint forwardStep = ccpMult(forwardMove, dt);
    
    // speed change
    
    // speed up and not slow down
    if(self.speedStatus == 1) {
        self.velocity = ccp(self.velocity.x * 1.00, self.velocity.y);
    }
    // slow down
    else if(self.speedStatus == 2){
        self.velocity = ccp(self.velocity.x * 0.95, self.velocity.y);
    }
    // normal
    else if (self.speedStatus == 0){
        self.velocity = ccp(self.velocity.x * 0.97, self.velocity.y);
    }
    
    
    self.velocity = ccpAdd(self.velocity, forwardStep);
    
    CGPoint minMovement = ccp(0.0, -450.0);
    CGPoint maxMovement = ccp(340.0, 500.0);
    self.velocity = ccpClamp(self.velocity, minMovement, maxMovement);
    
    self.velocity = ccpAdd(self.velocity, gravityStep);
    
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
}

-(CGRect)collisionBoundingBox {
    
    CGRect collisionBox = CGRectInset(self.boundingBox, 3, 0);
    //collisionBox = CGRectOffset(collisionBox, 0, -2);
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    return returnBoundingBox;
    
}



@end
