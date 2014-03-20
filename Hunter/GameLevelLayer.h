//
//  GameLevelLayer.h
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface GameLevelLayer : CCLayer {
    CCLabelBMFont * _statusLabel;
    CCLabelBMFont * _speedLabel;
    CCLabelBMFont * _distanceLabel;
    float time;
}


+(CCScene *) scene;

@property (nonatomic, assign) float time;

@end
