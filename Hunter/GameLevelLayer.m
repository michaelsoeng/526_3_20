//
//  GameLevelLayer.m
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.


#import "GameLevelLayer.h"
#import "Player.h"
#import "SpeedyPlayer.h"
#import "SlowPlayer.h"
#import "FollowEnemy.h"
#import "NormalEnemy.h"
#import "NormalEnemy2.h"
#import "AttackEnemy.h"
#import "AttackEnemy2.h"
#import "Projectile.h"
#import "SecondProjectile.h"
#import "FollowingProjectile.h"
#import "GoldCoin.h"
#import "SimpleAudioEngine.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"

@interface GameLevelLayer() {
    CCTMXTiledMap *map;
    CCTMXLayer *walls;
    CCTMXLayer *hazards;
    CCTMXLayer *magnets;
    CCTMXLayer *energyPills;
    CCTMXLayer *redcrosses;
    CCTMXObjectGroup *followEnemyObjectGroup;
    CCTMXObjectGroup *normalEnemyObjectGroup;
    CCTMXObjectGroup *normalEnemy2ObjectGroup;
    CCTMXObjectGroup *attackEnemyObjectGroup;
    CCTMXObjectGroup *attackEnemy2ObjectGroup;
    CCTMXObjectGroup *goldCoinObjectGroup;
    
    Player *player;
    SpeedyPlayer *speedyPlayer;
    SlowPlayer *slowPlayer;
    FollowEnemy *followEnemy;
    NormalEnemy *normalEnemy;
    NormalEnemy2 *normalEnemy2;
    AttackEnemy *attackEnemy;
    AttackEnemy2 *attackEnemy2;
    GoldCoin *goldCoin;
    
    CGSize _screenSize;
    CCSprite* _bg1;
    CCSprite* _bg2;
    
    int curTime;
    
    CCSprite *accButtonSprite;
    CCSprite *enrgNum;
    
    //CCProgressTimer *healthBarBK;
    CCProgressTimer *healthBarRemaining;
    BOOL gameOver;
    
}
@property (strong) NSMutableArray *collisionEnemies;
@property (strong) NSMutableArray *attackEnemies;
@property (strong) NSMutableArray *attack2Enemies;
@property (strong) NSMutableArray *followEnemies;

@property (strong) NSMutableArray *projectiles;
@property (strong) NSMutableArray *mudBalls;
@property (strong) NSMutableArray *goldCoins;
@end

@implementation GameLevelLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLevelLayer *layer = [GameLevelLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"level1.mp3"];
        self.isTouchEnabled = YES;
        //CCLayerColor *blueSky = [[CCLayerColor alloc] initWithColor:ccc4(100, 100, 250, 255)];
        //[self addChild:blueSky];
        
        // dynamic background
        _screenSize = [CCDirector sharedDirector].winSize;
        
        _bg1 = [CCSprite spriteWithFile:@"back_forests_left.png"];
        _bg1.position = CGPointMake(0, _screenSize.height * 0.5f);
        _bg1.anchorPoint = CGPointMake(0, 0.5f);
        [self addChild:_bg1];
        
        _bg2 = [CCSprite spriteWithFile:@"back_forests_right.png"];
        _bg2.position = CGPointMake(_bg2.contentSize.width, _bg1.position.y);
        _bg2.anchorPoint = CGPointMake(0, 0.5f);
        [self addChild:_bg2];
        map = [[CCTMXTiledMap alloc] initWithTMXFile:@"level4.tmx"];
        [self addChild:map];
        
        
        /**************************************************************
         *                       self initializaiton
         **************************************************************/
        self.collisionEnemies = [[NSMutableArray alloc] init];
        self.attackEnemies = [[NSMutableArray alloc] init];
        self.attack2Enemies = [[NSMutableArray alloc] init];
        self.followEnemies = [[NSMutableArray alloc] init];
        self.projectiles = [[NSMutableArray alloc] init];
        self.mudBalls = [[NSMutableArray alloc] init];
        self.goldCoins = [[NSMutableArray alloc] init];
        
        /**************************************************************
         *                       read object group from tiled
         **************************************************************/
        followEnemyObjectGroup = [map objectGroupNamed:@"followEnemy"];
        normalEnemyObjectGroup = [map objectGroupNamed:@"normalEnemy"];
        normalEnemy2ObjectGroup = [map objectGroupNamed:@"normalEnemy2"];
        attackEnemyObjectGroup = [map objectGroupNamed:@"attackEnemy"];
        attackEnemy2ObjectGroup = [map objectGroupNamed:@"attackEnemy2"];
        goldCoinObjectGroup = [map objectGroupNamed:@"goldCoin"];

        
        /**************************************************************
         *                             player           
         **************************************************************/
        player = [[Player alloc] initWithFile:@"Icon.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        player.position = ccp(winSize.width/4, 100);
        [map addChild:player z:15];
        [player playerInitAnimation:player];
        [player runAction:player.normalRunAnimation];
        
        /**************************************************************
         *                             speedy player
         **************************************************************/
        speedyPlayer = [[SpeedyPlayer alloc] initWithFile:@"Icon.png"];
        speedyPlayer.position = ccp(winSize.width/4, 100);
        [map addChild:speedyPlayer z:15];
        [speedyPlayer speedyPlayerInitAnimation:speedyPlayer];
        [speedyPlayer runAction:speedyPlayer.speedyRunAnimation];
        
        /**************************************************************
         *                             slow player
         **************************************************************/
        slowPlayer = [[SlowPlayer alloc] initWithFile:@"Icon.png"];
        slowPlayer.position = ccp(winSize.width/4, 100);
        [map addChild:slowPlayer z:15];
        [slowPlayer slowPlayerInitAnimation:slowPlayer];
        [slowPlayer runAction:slowPlayer.slowRunAnimation];

        
        /**************************************************************
         *                          follow enemy (flying dragon)
         **************************************************************/
        NSMutableDictionary *spawnPoint = [followEnemyObjectGroup objectNamed:@"followEnemySpawn"];
        for(spawnPoint in [followEnemyObjectGroup objects]){
            int x = [[spawnPoint valueForKey:@"x"] intValue];
            int y = [[spawnPoint valueForKey:@"y"] intValue];
            followEnemy = [[FollowEnemy alloc] initWithFile:@"Icon.png"];
            followEnemy.position = ccp(x, y);
            [map addChild:followEnemy z:15];
            [followEnemy animation:followEnemy];
            [self.followEnemies addObject:followEnemy];
            [self.collisionEnemies addObject:followEnemy];
        }
        
        
        /**************************************************************
         *                          normal enemy (turtle)
         **************************************************************/
        spawnPoint = [normalEnemyObjectGroup objectNamed:@"normalEnemySpawn"];
        for(spawnPoint in [normalEnemyObjectGroup objects]){
            float x = [[spawnPoint valueForKey:@"x"] floatValue];
            float y = [[spawnPoint valueForKey:@"y"] floatValue];
            normalEnemy = [[NormalEnemy alloc] initWithFile:@"Icon.png"];
            normalEnemy.position = ccp(x, y);
            [map addChild:normalEnemy z:15];
            [normalEnemy animation:normalEnemy];
            [normalEnemy backAndForth:normalEnemy];
            [self.collisionEnemies addObject:normalEnemy];

        }
        
        /**************************************************************
         *                        normal enemy 2 (bee)
         **************************************************************/
        spawnPoint = [normalEnemy2ObjectGroup objectNamed:@"normalEnemy2Spawn"];
        for(spawnPoint in [normalEnemy2ObjectGroup objects]){
            float x = [[spawnPoint valueForKey:@"x"] floatValue];
            float y = [[spawnPoint valueForKey:@"y"] floatValue];
            normalEnemy2 = [[NormalEnemy2 alloc] initWithFile:@"Icon.png"];
            normalEnemy2.position = ccp(x, y);
            [map addChild:normalEnemy2 z:15];
            [normalEnemy2 animation:normalEnemy2];
            [normalEnemy2 upAndDown:normalEnemy2];
            [self.collisionEnemies addObject:normalEnemy2];
        }

        
        /**************************************************************
         *                        attack enemy (mud monster 1)
         **************************************************************/
        spawnPoint = [attackEnemyObjectGroup objectNamed:@"attackEnemySpawn"];
        for(spawnPoint in [attackEnemyObjectGroup objects]){
            float x = [[spawnPoint valueForKey:@"x"] floatValue];
            float y = [[spawnPoint valueForKey:@"y"] floatValue];
            attackEnemy = [[AttackEnemy alloc] initWithFile:@"Icon.png"];
            attackEnemy.position = ccp(x, y);
            [map addChild:attackEnemy z:15];
            [attackEnemy animation:attackEnemy];
            [self.attackEnemies addObject:attackEnemy];
            [self.collisionEnemies addObject:attackEnemy];
        }
        
        /**************************************************************
         *                        attack enemy 2(mud monster 2)
         **************************************************************/
        spawnPoint = [attackEnemy2ObjectGroup objectNamed:@"attackEnemy2Spawn"];
        for(spawnPoint in [attackEnemy2ObjectGroup objects]){
            float x = [[spawnPoint valueForKey:@"x"] floatValue];
            float y = [[spawnPoint valueForKey:@"y"] floatValue];
            attackEnemy2 = [[AttackEnemy2 alloc] initWithFile:@"Icon.png"];
            attackEnemy2.position = ccp(x, y);
            [map addChild:attackEnemy2 z:15];
            [attackEnemy2 animation:attackEnemy2];
            [self.attack2Enemies addObject:attackEnemy2];
            [self.collisionEnemies addObject:attackEnemy2];
        }
        
        
        /**************************************************************
         *                        gold coins
         **************************************************************/
        spawnPoint = [goldCoinObjectGroup objectNamed:@"goldCoinSpawn"];
        for(spawnPoint in [goldCoinObjectGroup objects]){
            float x = [[spawnPoint valueForKey:@"x"] floatValue];
            float y = [[spawnPoint valueForKey:@"y"] floatValue];
            goldCoin = [[GoldCoin alloc] initWithFile:@"Coin.png"];
            goldCoin.position = ccp(x, y);
            [map addChild:goldCoin z:15];
            [goldCoin animation: goldCoin];
            [self.goldCoins addObject:goldCoin];
        }

        
        /**************************************************************
         *                        items and others
         **************************************************************/
        curTime = 0;
        
        accButtonSprite = [CCSprite spriteWithFile:@"accButton.png"];
        [self addChild:accButtonSprite];
        accButtonSprite.position = ccp(50, 50);
        enrgNum = nil;
        [self changeEnergyNum];
        
        time = 0;
        
        healthBarRemaining = nil;
        [self addHealthBarRemaining];
        
        walls = [map layerNamed:@"walls"];
        magnets = [map layerNamed:@"magnets"];
        energyPills = [map layerNamed:@"energy"];
        redcrosses = [map layerNamed:@"redcross"];
        
        _statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial.fnt"];
        _speedLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial.fnt"];
        _distanceLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial.fnt"];
        _statusLabel.position = ccp(player.position.x + 280, player.position.y + 200);
        _speedLabel.position = ccp(player.position.x + 280, player.position.y + 180);
        _distanceLabel.position = ccp(player.position.x + 280, player.position.y + 160);
        [self addChild:_statusLabel];
        [self addChild:_speedLabel];
        [self addChild:_distanceLabel];
       
        /**************************************************************
         *                        schedule update
         **************************************************************/
        [self schedule:@selector(systemUpdate:)];
        [self schedule:@selector(playerUpdate:)];
        [self schedule:@selector(speedyPlayerUpdate:) interval:0.01f];
        [self schedule:@selector(slowPlayerUpdate:) interval:0.01f];
        [self schedule:@selector(followEnemyFollowUpdate:) interval:0.2f];
        [self schedule:@selector(followEnemyShootUpdate:) interval:1.0f];  // use different time interval for shooting projectiles.
        [self schedule:@selector(attackEnemyShootUpdate:) interval:3.0f];
        [self schedule:@selector(attackEnemy2ShootUpdate:) interval:2.5f];

	}
	return self;
}

-(void)systemUpdate:(ccTime)dt {
    time += dt;
    if((int)time > curTime) curTime = (int)time;
    if (gameOver || player.HP.cur <= 0) {
        if(!gameOver)   [self gameOver: 0];
        return;
    }
    [self checkForWin];
    
    _statusLabel.string = [NSString stringWithFormat:@"Points: %d", curTime];
    _speedLabel.string = [NSString stringWithFormat:@"Speed: %d", player.hasMagnet ? 1 : 0];
    _distanceLabel.string = [NSString stringWithFormat:@"Distance: %d", (int)player.position.x];

    
    /**************************************************************
     *                        background update
     **************************************************************/
    CGPoint bg1Pos = _bg1.position;
    CGPoint bg2Pos = _bg2.position;
    bg1Pos.x -= 2;
    bg2Pos.x -= 2;
    
    // move scrolling background back from left to right end to achieve "endless" scrolling
    if (bg1Pos.x < -(_bg1.contentSize.width))
    {
        bg1Pos.x += _bg1.contentSize.width;
        bg2Pos.x += _bg2.contentSize.width;
    }
    
    // remove any inaccuracies by assigning only int values (this prevents floating point rounding errors accumulating over time)
    bg1Pos.x = (int)bg1Pos.x;
    bg2Pos.x = (int)bg2Pos.x;
    _bg1.position = bg1Pos;
    _bg2.position = bg2Pos;
}

-(void)playerUpdate:(ccTime)dt {
    [player update:dt];
    [self handleEnemyCollisions:player];
    [self handleProjectilesCollisions:player];
    [self handleMudballsCollisions:player];
    [self checkForAndResolveCollisions:player];
    [self setViewpointCenter:player.position];
    [self handleGoldCoinCollisions:player];
    
    // attack gold coins
    for (GoldCoin *g in self.goldCoins){
        if(player.hasMagnet && [g withinDistance:player byitself:g]) {
            [g followPlayer:player byitself:(GoldCoin*)g];
        }
    }
    
    // set up accelerate/ deccelerate lasting time/ keeping magnet time
    if(player.speedStatus == 1 && player.beginAccTime >= 0 && (int)time - player.beginAccTime == 3) {
        player.speedStatus = 0;
    }
    if(player.speedStatus == 2 && player.beginDecTime >= 0 && (int)time - player.beginDecTime == 2) {
        player.speedStatus = 0;
    }
    if(player.hasMagnet && player.beginMagTime >= 0 && (int)time - player.beginDecTime == 3) {
        player.hasMagnet = NO;
    }
    
    if(curTime % 10 == 0 && curTime == player.nextClearTableTime) {
        [player.lastObjects removeAllObjects];
        player.nextClearTableTime = curTime + 10;
    }
    
    // adapt different player animations for different speed mode
    if(player.speedStatus == 2){
        [slowPlayer setVisible:TRUE];
        [speedyPlayer setVisible:FALSE];
        [player setVisible:FALSE];
    }
    else if(player.speedStatus == 1){
        [slowPlayer setVisible:FALSE];
        [speedyPlayer setVisible:TRUE];
        [player setVisible:FALSE];
    }
    else{
        [slowPlayer setVisible:FALSE];
        [speedyPlayer setVisible:FALSE];
        [player setVisible:TRUE];
    }
}

-(void)speedyPlayerUpdate:(ccTime)dt {
    speedyPlayer.position = player.position;
    [speedyPlayer update:dt];
}
-(void)slowPlayerUpdate:(ccTime)dt {
    slowPlayer.position = player.position;
    [slowPlayer update:dt];
}

-(void) followEnemyFollowUpdate:(ccTime)dt {
    [followEnemy followPlayer:player.position byitself:followEnemy];
}

-(void) followEnemyShootUpdate:(ccTime)dt {
    for (FollowEnemy *enemy in self.followEnemies){
        [self shootPlayerFromFollowEnemy:enemy];
    }
}

-(void) attackEnemyShootUpdate:(ccTime)dt {
    for (AttackEnemy *enemy in self.attackEnemies){
        [self shootPlayerFromAttackEnemy:enemy];
    }
}

-(void) attackEnemy2ShootUpdate:(ccTime)dt {
    for (AttackEnemy2 *enemy in self.attack2Enemies){
        [self shootPlayerFromAttackEnemy2:enemy];
    }
    
}


/**************************************************************
 *                        speed up button
 **************************************************************/


-(Boolean)checkAccButton: (CGPoint)tt {
    if(ccpLength(ccpSub(tt, ccp(50, 50))) < 50) return true;
    return false;
}

/**************************************************************
 *                       health bar
 **************************************************************/

-(void) addHealthBarRemaining {
    healthBarRemaining = [ CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"heart_five.png"]];
    healthBarRemaining.type = kCCProgressTimerTypeBar;
    healthBarRemaining.midpoint = ccp(0, 0);
    healthBarRemaining.barChangeRate = ccp(1, 0);
    healthBarRemaining.position = ccp(10, 290);
    healthBarRemaining.anchorPoint = ccp(0, 0);
    healthBarRemaining.percentage = 100;
    [self addChild:healthBarRemaining z:16];
}

-(void) updateHealthBarRemaining {
    healthBarRemaining.percentage = player.HP.cur * 10;
}

/******************************************************************************
 *                         player collisions
 ******************************************************************************/
-(void)handleGoldCoinCollisions:(Player *)p {
    NSMutableArray *coinsToDelete = [[NSMutableArray alloc] init];
    
    for (GoldCoin *g in self.goldCoins){
        if (ccpLength(ccpSub(g.position, player.position)) < 50 || (p.hasMagnet && ccpLength(ccpSub(g.position, player.position)) < 100)) {
            [coinsToDelete addObject: g];
            if(![p.lastObjects containsObject:g]) {
                [p.lastObjects addObject:g];
                [p.Coin add:1];
            }
        }
    }
    for (CCSprite *g in coinsToDelete){
        [self.goldCoins removeObject: g];
        [self removeChild:g cleanup:YES];
        [map removeChild:g cleanup:YES];
    }
}

-(void)handleEnemyCollisions:(Player *)p {
    
    CGRect pRect = [p collisionBoundingBox];
    for (CCSprite *enemy in self.collisionEnemies){
        CGRect eRect = CGRectMake(
                                  enemy.position.x - (enemy.contentSize.width/2),
                                  enemy.position.y - (enemy.contentSize.height/2),
                                  enemy.contentSize.width,
                                  enemy.contentSize.height);
        if (CGRectIntersectsRect(pRect, eRect) && ![p.lastObjects containsObject: enemy] && p.speedStatus != 1) {
            [p.HP add: -1];
            [self updateHealthBarRemaining];
            [p.lastObjects addObject:enemy];
            p.speedStatus = 2;
            p.beginDecTime = curTime;
        }
    }
}

-(void) handleMudballsCollisions:(Player *)p {
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    
    CGRect pRect = [p collisionBoundingBox];
    for (CCSprite *projectile in self.mudBalls){
        CGRect eRect = CGRectMake(
                                  projectile.position.x - (projectile.contentSize.width/2),
                                  projectile.position.y - (projectile.contentSize.height/2),
                                  projectile.contentSize.width,
                                  projectile.contentSize.height);
        if (CGRectIntersectsRect(pRect, eRect)) {
            [projectilesToDelete addObject:projectile];
            if(p.speedStatus != 1) {
                p.speedStatus = 2;
                p.beginDecTime = curTime;
            }
            
        }
    }
    for (CCSprite *projectile in projectilesToDelete){
        [self.projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
        [map removeChild:projectile cleanup:YES];
    }
}

-(void)handleProjectilesCollisions:(Player *)p {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    
    CGRect pRect = [p collisionBoundingBox];
    for (CCSprite *projectile in self.projectiles){
        CGRect eRect = CGRectMake(
                                  projectile.position.x - (projectile.contentSize.width/2),
                                  projectile.position.y - (projectile.contentSize.height/2),
                                  projectile.contentSize.width,
                                  projectile.contentSize.height);
        if (CGRectIntersectsRect(pRect, eRect)) {
            [projectilesToDelete addObject:projectile];
            if(![p.lastObjects containsObject:projectile] && p.speedStatus != 1){
                [p.HP add:-1];
                [self updateHealthBarRemaining];
                [p.lastObjects addObject:projectile];
            }
        }
    }
    for (CCSprite *projectile in projectilesToDelete){
        [self.projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
        [map removeChild:projectile cleanup:YES];
    }
}

/******************************************************************************
 *                         shoot player
 ******************************************************************************/
-(void)shootPlayerFromAttackEnemy:(AttackEnemy *)e {
    
    Projectile *projectile = [[Projectile alloc] initWithFile:@"P05.png"];
    [projectile animation:projectile];
    
    projectile.position = ccp(e.position.x-30,e.position.y-10);
    [map addChild:projectile z:14];
    [self.mudBalls addObject:projectile];

    CGPoint dest = player.position;
    
    // Determine the length of how far we're shooting
    int diffX = dest.x - projectile.position.x;
    int diffY = dest.y - projectile.position.y;
    
    if(abs(diffX) < 1000 && abs(diffY) < 1000){
        float length = sqrtf((diffX*diffX) + (diffY*diffY));
        float velocity = 60/1; // pixels/1sec
        float moveDuration = length/velocity;
    
        // Move projectile to actual endpoint
        id actionMove1 = [CCMoveTo actionWithDuration:moveDuration
                                             position:dest];
        [projectile runAction: actionMove1];
    }
}

-(void)shootPlayerFromAttackEnemy2:(AttackEnemy2 *)e {
    
    SecondProjectile *projectile = [[SecondProjectile alloc] initWithFile:@"P05.png"];
    [projectile animation:projectile];

    projectile.position = ccp(e.position.x-30,e.position.y-10);
    [map addChild:projectile z:14];
    [self.mudBalls addObject:projectile];
    
    CGPoint dest;
    dest.x = 0;
    dest.y = e.position.y;
    
    // Determine the length of how far we're shooting
    int diffX = dest.x - projectile.position.x;
    int diffY = dest.y - projectile.position.y;
    
    if(abs(diffX) < 2000){
        float length = sqrtf((diffX*diffX) + (diffY*diffY));
        float velocity = 60/1; // pixels/1sec
        float moveDuration = length/velocity;
        
        // Move projectile to actual endpoint
        id actionMove1 = [CCMoveTo actionWithDuration:moveDuration
                                             position:dest];
        [projectile runAction: actionMove1];
    }
}

-(void)shootPlayerFromFollowEnemy:(FollowEnemy *)e {
    
    FollowingProjectile *projectile = [[FollowingProjectile alloc] initWithFile:@"P05.png"];
    [projectile animation:projectile];

    int x1 = e.position.x +40;
    int y1 = e.position.y-10;
    projectile.position= ccp(x1,y1);
    [map addChild:projectile z:14];
    [self.projectiles addObject:projectile];
    
    CGPoint dest;
    dest.x = player.position.x + 300;
    dest.y = player.position.y - 1000;
    
    // Determine the length of how far we're shooting
    int diffX = dest.x - projectile.position.x;
    int diffY = dest.y - projectile.position.y;
    
  //  if(abs(diffX) < 1000 && abs(diffY) < 1000){
        float length = sqrtf((diffX*diffX) + (diffY*diffY));
        float velocity = 60/1; // pixels/1sec
        float moveDuration = length/velocity;
        
        // Move projectile to actual endpoint
        id actionMove1 = [CCMoveTo actionWithDuration:moveDuration
                                             position:dest];
        [projectile runAction: actionMove1];
  //  }
}

/******************************************************************************
 *                          others
 ******************************************************************************/

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    float x = floor(position.x / (map.tileSize.width / CC_CONTENT_SCALE_FACTOR()));
    float levelHeightInPixels = map.mapSize.height * (map.tileSize.height / CC_CONTENT_SCALE_FACTOR());
    float y = floor((levelHeightInPixels - position.y) / (map.tileSize.height / CC_CONTENT_SCALE_FACTOR()));
    return ccp(x, y);
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords {
    float levelHeightInPixels = map.mapSize.height * (map.tileSize.height / CC_CONTENT_SCALE_FACTOR());
    CGPoint origin = ccp(tileCoords.x * (map.tileSize.width / CC_CONTENT_SCALE_FACTOR()), levelHeightInPixels - ((tileCoords.y + 1) * (map.tileSize.height / CC_CONTENT_SCALE_FACTOR())));
    return CGRectMake(origin.x, origin.y, (map.tileSize.width / CC_CONTENT_SCALE_FACTOR()), (map.tileSize.height / CC_CONTENT_SCALE_FACTOR()));
}


//-(void)handleHazardCollisions:(Player *)p {
//    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:hazards ];
//    for (NSDictionary *dic in tiles) {
//        CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], (map.tileSize.width / CC_CONTENT_SCALE_FACTOR()), (map.tileSize.height / CC_CONTENT_SCALE_FACTOR()));
//        CGRect pRect = [p collisionBoundingBox];
//        
//        if ([[dic objectForKey:@"gid"] intValue] && CGRectIntersectsRect(pRect, tileRect)) {
//            [self gameOver:0];
//        }
//    }
//}

-(void)isTouchRedcross: (Player*)p {
    CGPoint tileCoord = [self tileCoordForPosition:p.position];
    int tileGid = [redcrosses tileGIDAt:tileCoord];
    NSDictionary *properties = [map propertiesForGID:tileGid];
    NSString *collectable = [properties valueForKey:@"Collectable"];
    if(collectable && [collectable compare:@"True"] == NSOrderedSame) {
        [redcrosses removeTileAt:tileCoord];
        [p.HP add: 1];
        [self updateHealthBarRemaining];
    }
}

-(void)isTouchMagnet: (Player*)p {
    CGPoint tileCoord = [self tileCoordForPosition:p.position];
    int tileGid = [magnets tileGIDAt:tileCoord];
    NSDictionary *properties = [map propertiesForGID:tileGid];
    NSString *collectable = [properties valueForKey:@"Collectable"];
    if(collectable && [collectable compare:@"True"] == NSOrderedSame) {
        [magnets removeTileAt:tileCoord];
        p.hasMagnet = YES;
        p.beginMagTime = (int)time;
    }
}

-(void)isTouchEnergyPill: (Player*)p {
    CGPoint tileCoord = [self tileCoordForPosition:p.position];
    int tileGid = [energyPills tileGIDAt:tileCoord];
    NSDictionary *properties = [map propertiesForGID:tileGid];
    NSString *collectable = [properties valueForKey:@"Collectable"];
    if(collectable && [collectable compare:@"True"] == NSOrderedSame) {
        [energyPills removeTileAt:tileCoord];
        [p.Energy add: 1];
        [self changeEnergyNum];
    }
}

-(void)changeEnergyNum {
    if(enrgNum != nil) {
        [self removeChild:enrgNum cleanup:YES];
        [map removeChild:enrgNum cleanup:YES];
        enrgNum = nil;
    }
    if(player.Energy.cur > 0) {
        [accButtonSprite setVisible: YES];
        NSMutableString *str = [NSMutableString stringWithString: @"num_.png"];
        [str insertString: [NSString stringWithFormat:@"%d", player.Energy.cur] atIndex:4];
        enrgNum = [CCSprite spriteWithFile: str];
        [self addChild: enrgNum];
        enrgNum.position = ccp(50, 50);
    }
    else {
        [accButtonSprite setVisible: NO];
    }
}



- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *tt in touches) {
        CGPoint touchLocation = [self convertTouchToNodeSpace:tt];
        if (touchLocation.x > 240) {
            player.mightAsWellJump = YES;
            speedyPlayer.mightAsWellJump = YES;
            slowPlayer.mightAsWellJump = YES;
        }
        else if([self checkAccButton : touchLocation] && player.Energy.cur > 0 && player.speedStatus != 1) {
            player.speedStatus = 1;
            player.beginAccTime = curTime;
            [player.Energy add: -1];
            [self changeEnergyNum];
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *tt in touches) {
        
        CGPoint touchLocation = [self convertTouchToNodeSpace:tt];
        
        //get previous touch and convert it to node space
        CGPoint previousTouchLocation = [tt previousLocationInView:[tt view]];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        previousTouchLocation = ccp(previousTouchLocation.x, screenSize.height - previousTouchLocation.y);
        
        if (touchLocation.x > 240 && previousTouchLocation.x <= 240) {
            player.forwardMarch = NO;
            player.mightAsWellJump = YES;
            speedyPlayer.mightAsWellJump = YES;
            slowPlayer.mightAsWellJump = YES;
        } else if (previousTouchLocation.x > 240 && touchLocation.x <=240) {
            player.forwardMarch = YES;
            player.mightAsWellJump = NO;
            speedyPlayer.mightAsWellJump = NO;
            slowPlayer.mightAsWellJump = NO;
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *tt in touches) {
        CGPoint touchLocation = [self convertTouchToNodeSpace:tt];
        if (touchLocation.x < 240) {
            player.forwardMarch = NO;
        } else {
            player.mightAsWellJump = NO;
            speedyPlayer.mightAsWellJump = NO;
            slowPlayer.mightAsWellJump = NO;
        }
    }
}

-(void)gameOver:(BOOL)won {
	gameOver = YES;
	NSString *gameText;
	
	if (won) {
		gameText = @"You Won!";
	} else {
		gameText = @"You have Died!";
        //[[SimpleAudioEngine sharedEngine] playEffect:@"hurt.wav"];
	}
	
    CCLabelTTF *diedLabel = [[CCLabelTTF alloc] initWithString:gameText fontName:@"Marker Felt" fontSize:40];
    diedLabel.position = ccp(240, 200);
    CCMoveBy *slideIn = [[CCMoveBy alloc] initWithDuration:1.0 position:ccp(0, 250)];
    CCMenuItemImage *replay = [[CCMenuItemImage alloc] initWithNormalImage:@"replay.png" selectedImage:@"replay.png" disabledImage:@"replay.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[GameLevelLayer scene]];
    }];
    
    NSArray *menuItems = [NSArray arrayWithObject:replay];
    CCMenu *menu = [[CCMenu alloc] initWithArray:menuItems];
    menu.position = ccp(240, -100);
    
    [self addChild:menu];
    [self addChild:diedLabel];
    
    [menu runAction:slideIn];
}

-(void)checkForWin {
    if (player.position.x > 100000.0) {
        [self gameOver:1];
    }
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (map.mapSize.width * (map.tileSize.width / CC_CONTENT_SCALE_FACTOR())) 
            - winSize.width / 2);
    y = MIN(y, (map.mapSize.height * (map.tileSize.height / CC_CONTENT_SCALE_FACTOR())) 
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/4, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    map.position = viewPoint; 
}


-(NSArray *)getSurroundingTilesAtPosition:(CGPoint)position forLayer:(CCTMXLayer *)layer {
    
    CGPoint plPos = [self tileCoordForPosition:position]; //1
    
    NSMutableArray *gids = [NSMutableArray array]; //2
    
    for (int i = 0; i < 9; i++) { //3
        int c = i % 3;
        int r = (int)(i / 3);
        CGPoint tilePos = ccp(plPos.x + (c - 1), plPos.y + (r - 1));
        
        if (tilePos.y > (map.mapSize.height - 1)) {
            //fallen in a hole
            [self gameOver:0];
            return nil;
        }
        
        int tgid = [layer tileGIDAt:tilePos]; //4
        
        CGRect tileRect = [self tileRectFromTileCoords:tilePos]; //5
        
        NSDictionary *tileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:tgid], @"gid",
                                  [NSNumber numberWithFloat:tileRect.origin.x], @"x",
                                  [NSNumber numberWithFloat:tileRect.origin.y], @"y",
                                  [NSValue valueWithCGPoint:tilePos],@"tilePos",
                                  nil];
        [gids addObject:tileDict]; //6
        
    }
    
    [gids removeObjectAtIndex:4]; //7
    [gids insertObject:[gids objectAtIndex:2] atIndex:6];
    [gids removeObjectAtIndex:2];
    [gids exchangeObjectAtIndex:4 withObjectAtIndex:6];
    [gids exchangeObjectAtIndex:0 withObjectAtIndex:4];
    
    return (NSArray *)gids;
}


-(void)checkForAndResolveCollisions:(Player *)p {
    
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:walls ]; //1
    if (gameOver) {
        return;
    }
    p.onGround = NO;
    
    for (NSDictionary *dic in tiles) {
        CGRect pRect = [p collisionBoundingBox]; //3
        
        int gid = [[dic objectForKey:@"gid"] intValue]; //4
        
        if (gid) {
            CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], (map.tileSize.width / CC_CONTENT_SCALE_FACTOR()), (map.tileSize.height / CC_CONTENT_SCALE_FACTOR())); //5
            if (CGRectIntersectsRect(pRect, tileRect)) {
                CGRect intersection = CGRectIntersection(pRect, tileRect);
                int tileIndx = [tiles indexOfObject:dic];
                
                if (tileIndx == 0) {
                    //tile is directly below player
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                    p.onGround = YES;
                } else if (tileIndx == 1) {
                    //tile is directly above player
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y - intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                } else if (tileIndx == 2) {
                    //tile is left of player
                    p.desiredPosition = ccp(p.desiredPosition.x + intersection.size.width, p.desiredPosition.y);
                } else if (tileIndx == 3) {
                    //tile is right of player
                    p.desiredPosition = ccp(p.desiredPosition.x - intersection.size.width, p.desiredPosition.y);
                    //p.velocity = ccp(p.velocity.x, 0.0);
                } else {
                    if (intersection.size.width > intersection.size.height) {
                        //tile is diagonal, but resolving collision vertially
                        p.velocity = ccp(p.velocity.x, 0.0);
                        float resolutionHeight;
                        if (tileIndx > 5) {
                            resolutionHeight = -intersection.size.height;
                            p.onGround = YES;
                        } else {
                            resolutionHeight = intersection.size.height;
                        }
                        
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + resolutionHeight );
                        
                    } else {
                        float resolutionWidth;
                        if (tileIndx == 6 || tileIndx == 4) {
                            resolutionWidth = intersection.size.width;
                        } else {
                            resolutionWidth = -intersection.size.width;
                        }
                        p.desiredPosition = ccp(p.desiredPosition.x + resolutionWidth , p.desiredPosition.y);
                        
                    }
                }
            }
        }
    }
    
    [self isTouchRedcross: p];
    [self isTouchMagnet: p];
    [self isTouchEnergyPill: p];
    p.position = p.desiredPosition; //8
}


@end
