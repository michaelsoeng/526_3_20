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

@implementation Player

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;
@synthesize forwardMarch = _forwardMarch, mightAsWellJump = _mightAsWellJump;
@synthesize speedyRun = _speedyRun;

-(id)initWithFile:(NSString *)filename {
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}

- (void) playerInitAnimation:(Player*) p
{
    id actionMove1 = [CCRepeatForever actionWithAction:[
                                                     CCAnimate actionWithSpriteSequence:@"player_normal_run_%d.png"
                                                     numFrames:4
                                                     delay:0.1
                                                     restoreOriginalFrame:NO]];
    [p runAction: actionMove1];
}

- (void) playerRunAnimation:(Player*) p
{
    id actionMove1 = 0;
    if(self.speedyRun){
        actionMove1 = [CCRepeatForever actionWithAction:[
                        CCAnimate actionWithSpriteSequence:@"player_speedy_run_%d.png"
                                                 numFrames:4
                                                     delay:0.1
                                      restoreOriginalFrame:NO]];
    }
    else{
        actionMove1 = [CCRepeatForever actionWithAction:[
                        CCAnimate actionWithSpriteSequence:@"player_normal_run_%d.png"
                                                 numFrames:4
                                                     delay:0.1
                                      restoreOriginalFrame:NO]];
    }
    [p runAction: actionMove1];
    
}



-(void)update:(ccTime)dt {
    CGPoint jumpForce = ccp(0.0, 900.0);
    float jumpCutoff = 150.0;
    
    // normal jump animation
    if(!self.speedyRun && self.mightAsWellJump){
        id actionMove1 = [
                          CCAnimate actionWithSpriteSequence:@"player_normal_jump_%d.png"
                          numFrames:1
                          delay:0.1
                          restoreOriginalFrame:NO];
        [self runAction: actionMove1];
    }
    
    // speedy jump animation
    if(self.speedyRun && self.mightAsWellJump){
        id actionMove1 = [
                          CCAnimate actionWithSpriteSequence:@"player_speedy_jump_%d.png"
                          numFrames:1
                          delay:0.1
                          restoreOriginalFrame:NO];
        [self runAction: actionMove1];
    }

    
    if (self.mightAsWellJump && self.onGround) {
        self.velocity = ccpAdd(self.velocity, jumpForce);
        [[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
    }
    else if (!self.mightAsWellJump && self.velocity.y > jumpCutoff) {
        self.velocity = ccp(self.velocity.x, jumpCutoff);
    }
    
    CGPoint gravity = ccp(0.0, -600.0);
    CGPoint gravityStep = ccpMult(gravity, dt);
    CGPoint forwardMove;
    
    // normal run and speedy run
    if(self.speedyRun){
        forwardMove = ccp(400.0, 0.0);
    }
    else{
        forwardMove = ccp(200.0, 0.0);
    }
    
    
    CGPoint forwardStep = ccpMult(forwardMove, dt);
    
    self.velocity = ccp(self.velocity.x * 1.90, self.velocity.y); //2
    
    self.forwardMarch = YES;
    if (self.forwardMarch) {
        self.velocity = ccpAdd(self.velocity, forwardStep);
    } //3
    
    CGPoint minMovement = ccp(0.0, -450.0);
    CGPoint maxMovement = ccp(240.0, 500.0);
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
