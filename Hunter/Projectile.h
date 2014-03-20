//
//  Projectile.h
//  Hunter
//
//  Created by Zhe Xie on 2/18/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"
@interface Projectile : CCSprite

@property (nonatomic, assign) CGPoint velocity;
- (void) animation:(Projectile*) projectile;

@end