//
//  SpeedyPlayer.h
//  Hunter
//
//  Created by Zhe Xie on 3/10/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NumAttribute.h"

@interface SpeedyPlayer : CCSprite

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) BOOL forwardMarch;
@property (nonatomic, assign) BOOL mightAsWellJump;

@property (nonatomic, strong) CCAction *speedyRunAnimation;

-(void)update:(ccTime)dt;
- (void) speedyPlayerInitAnimation:(SpeedyPlayer*) p;

@end

