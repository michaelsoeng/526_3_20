//
//  NormalEnemy2.m
//  Hunter
//
//  Created by Student on 3/8/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import "NormalEnemy2.h"
#import "SimpleAudioEngine.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"

@implementation NormalEnemy2

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize forwardMarch = _forwardMarch;
@synthesize playerPosition = _playerPosition;

-(id)initWithFile:(NSString *)filename{
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}

- (void) animation:(NormalEnemy2*) enemy
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"normal_enemy_2.plist"];
    
    // Create the actions
    id actionMove1 = [CCRepeatForever actionWithAction:[
                                                        CCAnimate actionWithSpriteSequence:@"normal_enemy_2_%d.png"
                                                        numFrames:2
                                                        delay:0.2
                                                        restoreOriginalFrame:NO]];
    [enemy runAction: actionMove1];
}

- (void) upAndDown:(NormalEnemy2*) enemy
{
    ccTime actualDuration = 3;
    CGPoint des;
    if(self.forwardMarch){
        des.x = enemy.position.x;
        des.y = enemy.position.y + 100;
        self.forwardMarch = false;
        
    }
    else{
        des.x = enemy.position.x;
        des.y = enemy.position.y - 100;
        self.forwardMarch = true;
        
    }
    
    
    // Create the actions
    id actionMove1 = [CCMoveTo actionWithDuration:actualDuration
                                         position:des];
    id actionMove2 = [CCCallFuncN actionWithTarget:self
                                          selector:@selector(enemyMoveFinished:)];
    
    
    id actionMoveSeq = [CCSequence actions:actionMove1, actionMove2, nil];
    
    [enemy runAction: actionMoveSeq];
    
    /* id actionMove1 = [
     CCAnimate actionWithSpriteSequence:@"player_speedy_jump_%d.png"
     numFrames:1
     delay:0.1
     restoreOriginalFrame:NO];
     */
}

// callback. starts another iteration of enemy movement.
- (void) enemyMoveFinished:(id)sender {
    NormalEnemy2 *enemy = (NormalEnemy2 *)sender;
    [self upAndDown: enemy];
}





@end