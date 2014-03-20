//
//  FollowingProjectile.h
//  Hunter
//
//  Created by Student on 3/9/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"
@interface FollowingProjectile : CCSprite

@property (nonatomic, assign) CGPoint velocity;
- (void) animation:(FollowingProjectile*) projectile;

@end
