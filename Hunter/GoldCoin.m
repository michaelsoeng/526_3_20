//
//  GoldCoin.m
//  Hunter
//
//  Created by Zhe Xie on 3/12/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import "GoldCoin.h"
#import "cocos2d.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"

@implementation GoldCoin

@synthesize velocity = _velocity;

-(id)initWithFile:(NSString *)filename{
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    return self;
}

- (void) animation:(GoldCoin*) g {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animatedCoin.plist"];
    
    // Create the actions
    id actionMove1 = [CCRepeatForever actionWithAction:[
                                                        CCAnimate actionWithSpriteSequence:@"gold_coin_%d.png"
                                                        numFrames:4
                                                        delay:0.1
                                                        restoreOriginalFrame:NO]];
    [g runAction: actionMove1];
}

-(void)followPlayer:(Player*)p  byitself:(GoldCoin*)g
{
    ccTime actualDuration = 10;
    CGPoint des = ccp(p.position.x + 100, p.position.y);
    
    
    // Create the actions
    id actionMove1 = [CCMoveTo actionWithDuration:actualDuration
                                         position:des];
    
    [g runAction: actionMove1];
}

-(BOOL)withinDistance:(Player*)p byitself:(GoldCoin*)g
{
    return  ccpLength(ccpSub(p.position, g.position)) < 500;
}

@end

