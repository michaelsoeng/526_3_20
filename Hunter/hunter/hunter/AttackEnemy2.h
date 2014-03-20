//
//  AttackEnemy2.h
//  Hunter
//
//  Created by Student on 3/9/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AttackEnemy2 : CCSprite

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) CGPoint playerPosition;

- (void) animation:(AttackEnemy2*) enemy;

@end




