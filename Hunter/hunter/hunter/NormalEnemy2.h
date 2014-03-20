//
//  NormalEnemy2.h
//
//  Created by Zhe Xie on 2/17/14.
//  Copyright (c) 2014 Interrobang Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NormalEnemy2: CCSprite

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) CGPoint playerPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) BOOL forwardMarch;

- (void) animation:(NormalEnemy2*) enemy;
- (void) upAndDown:(NormalEnemy2*) enemy;

@end