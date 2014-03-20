//
//  Player.h
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.
//  Copyright 2012 Interrobang Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NumAttribute.h"

@interface Player : CCSprite 

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) BOOL forwardMarch;
@property (nonatomic, assign) BOOL mightAsWellJump;

@property (nonatomic, assign) int speedStatus;

// accelerate
@property (nonatomic, assign) int beginAccTime;

// deccelerate
@property (nonatomic, assign) int beginDecTime;

// has magnet
@property (nonatomic, assign) int beginMagTime;
@property (nonatomic, assign) BOOL hasMagnet;

@property (nonatomic, assign) NumAttribute *HP;
@property (nonatomic, assign) NumAttribute *Coin;
@property (nonatomic, assign) NumAttribute *Energy;


@property (nonatomic, strong) CCAction *normalRunAnimation;
@property (nonatomic, strong) CCAction *speedyRunAnimation;

//@property (nonatomic, strong) CCSprite *lastEnemy;
@property (nonatomic, assign) NSHashTable *lastObjects;
@property (nonatomic, assign) int nextClearTableTime;
//@property (nonatomic, strong) CCSprite *lastProjectile;
//@property (nonatomic, strong) CCSprite *lastCoin;

-(void)update:(ccTime)dt;
- (void) playerInitAnimation:(Player*) p;
//- (void) playerRunAnimation:(Player*) p;
-(CGRect)collisionBoundingBox;

@end

