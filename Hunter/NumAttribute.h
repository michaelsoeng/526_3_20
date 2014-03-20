//
//  NumAttribute.h
//  Hunter
//
//  Created by Student on 3/9/14.
//  Copyright 2014 usc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NumAttribute : NSObject
@property (nonatomic, assign) int cur;
@property (nonatomic, assign) int upperLimit;
@property (nonatomic, assign) int lowerLimit;

-(void)add: (int)val;
-(void)setVal: (int)val;
-(void)checkLimit;

@end
