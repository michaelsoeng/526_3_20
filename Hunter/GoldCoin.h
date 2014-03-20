//
//  GoldCoin.h
//  Hunter
//
//  Created by Zhe Xie on 3/12/14.
//  Copyright (c) 2014 usc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface  GoldCoin : CCSprite;

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;

-(void)animation:(GoldCoin*) g;
-(void)followPlayer:(Player*)p  byitself:(GoldCoin*)g;
-(BOOL)withinDistance:(Player*)p byitself:(GoldCoin*)g;



@end

