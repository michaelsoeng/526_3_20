//
//  Enemy.h
//  SuperKoalio
//
//  Created by Zhe Xie on 2/16/14.
//  Copyright (c) 2014 Interrobang Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FollowEnemy: CCSprite

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) CGPoint playerPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) BOOL forwardMarch;

- (void) animation:(FollowEnemy*) enemy;
//- (void) moveForward:(FollowEnemy*) enemy;
//-(void)followPlayer:(ccTime)dt aboutPlayer:(CGPoint)playerPos;
-(void)followPlayer:(CGPoint)playerPos byitself:(FollowEnemy*)enemy;
//-(CGRect)collisionBoundingBox;

@end
