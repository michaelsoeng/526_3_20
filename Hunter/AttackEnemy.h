//
//  AttackEnemy.h
//  Hunter
//
//  Created by Zhe Xie on 2/18/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AttackEnemy : CCSprite

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) CGPoint playerPosition;

//-(void)shootPlayer:(ccTime)dt onMap:(CCTMXTiledMap*)map aboutPlayer:(CGPoint)playerPos;
//- (void) shootProjectile:(AttackEnemy*)enemy;

- (void) animation:(AttackEnemy*) enemy;

@end
