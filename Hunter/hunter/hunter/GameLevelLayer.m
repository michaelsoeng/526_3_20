//
//  GameLevelLayer.m
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.


#import "GameLevelLayer.h"
#import "Player.h"
#import "FollowEnemy.h"
#import "NormalEnemy.h"
#import "NormalEnemy2.h"
#import "AttackEnemy.h"
#import "AttackEnemy2.h"
#import "Projectile.h"
#import "SimpleAudioEngine.h"
#import "CCAnimate+SequenceLoader.h"
#import "CCAnimation+SequenceLoader.h"

@interface GameLevelLayer() {
    CCTMXTiledMap *map;
    CCTMXLayer *walls;
    CCTMXLayer *hazards;
    CCTMXObjectGroup *followEnemyObjectGroup;
    CCTMXObjectGroup *normalEnemyObjectGroup;
    CCTMXObjectGroup *normalEnemy2ObjectGroup;
    CCTMXObjectGroup *attackEnemyObjectGroup;
    CCTMXObjectGroup *attackEnemy2ObjectGroup;
    
    Player *player;
    FollowEnemy *followEnemy;
    NormalEnemy *normalEnemy;
    NormalEnemy2 *normalEnemy2;
    AttackEnemy *attackEnemy;
    AttackEnemy2 *attackEnemy2;
    
    CGSize _screenSize;
    CCSprite* _bg1;
    CCSprite* _bg2;
    
    ///////////////////////////////////Coin Properties Start//////////////////////
    int numCollected;
    int remainingCoins;
    int numAcc;
    CCSprite *accButtonSprite;
    Boolean buttonExist;
    ///////////////////////////////////Coin Properties End//////////////////////
    
    BOOL gameOver;
    
}
@property (strong) NSMutableArray *collisionEnemies;
@property (strong) NSMutableArray *attackEnemies;
@property (strong) NSMutableArray *projectiles;
@property (strong) NSMutableArray *followingEnemies;
@property (strong) NSMutableArray *followingProjectiles;
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
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"level1.mp3"];
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
        map = [[CCTMXTiledMap alloc] initWithTMXFile:@"level3_trial.tmx"];
        [self addChild:map];
        
        /**************************************************************
         *                             player           
         **************************************************************/
        player = [[Player alloc] initWithFile:@"kuwalio_stand-hd.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        player.position = ccp(winSize.width/4, 100);
        [map addChild:player z:15];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_normal_run.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_normal_jump.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_speedy_run.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_speedy_jump.plist"];
        [player playerInitAnimation:player];
        
        walls = [map layerNamed:@"walls"];
        
        //coins = [map layerNamed:@"Coin"];
        //_statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial.fnt"];
        //_statusLabel.position = ccp(player.position.x + 280, player.position.y + 200);
        //[self addChild:_statusLabel];
        
        /**************************************************************
         *                             enemy
         **************************************************************/
        //hazards = [map layerNamed:@"hazards"];
        followEnemyObjectGroup = [map objectGroupNamed:@"followEnemy"];
        normalEnemyObjectGroup = [map objectGroupNamed:@"normalEnemy"];
        normalEnemy2ObjectGroup = [map objectGroupNamed:@"normalEnemy2"];
        attackEnemyObjectGroup = [map objectGroupNamed:@"attackEnemy"];
        attackEnemy2ObjectGroup = [map objectGroupNamed:@"attackEnemy2"];
        
        
        //////////////////////////// initialization //////////////////////////////////
        self.collisionEnemies = [[NSMutableArray alloc] init];
        self.attackEnemies = [[NSMutableArray alloc] init];
        self.projectiles = [[NSMutableArray alloc] init];
        self.followingEnemies = [[NSMutableArray alloc] init];
        self.followingProjectiles = [[NSMutableArray alloc] init];
        
        //////////////////////////// add follow enemy //////////////////////////////////
        // create enemy from object group
        NSMutableDictionary *spawnPoint = [followEnemyObjectGroup objectNamed:@"followEnemySpawn"];
        for(spawnPoint in [followEnemyObjectGroup objects]){
        int x = [[spawnPoint valueForKey:@"x"] intValue];
        int y = [[spawnPoint valueForKey:@"y"] intValue];
        followEnemy = [[FollowEnemy alloc] initWithFile:@"player-hd.png"];
        followEnemy.position = ccp(x, y);
        [map addChild:followEnemy z:15];
        [self.followingEnemies addObject:followEnemy];
        }
        
        
        //////////////////////////// add normal enemy //////////////////////////////////
        spawnPoint = [normalEnemyObjectGroup objectNamed:@"normalEnemySpawn"];
        for(spawnPoint in [normalEnemyObjectGroup objects]){
            float x = [[spawnPoint valueForKey:@"x"] floatValue];
            float y = [[spawnPoint valueForKey:@"y"] floatValue];
            //printf("input: %f %f\n", x, y);
            normalEnemy = [[NormalEnemy alloc] initWithFile:@"monster-hd.png"];
            normalEnemy.position = ccp(x, y);
            [map addChild:normalEnemy z:15];
            [self.collisionEnemies addObject:normalEnemy];
            
           // [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"normal_enemy_1_back.plist"];
            [normalEnemy animation:normalEnemy];
            [normalEnemy backAndForth:normalEnemy];
        }
        
        //////////////////////////// add normal enemy 2 //////////////////////////////////
        spawnPoint = [normalEnemy2ObjectGroup objectNamed:@"normalEnemy2Spawn"];
        for(spawnPoint in [normalEnemy2ObjectGroup objects]){
            float x = [[spawnPoint valueForKey:@"x"] floatValue];
            float y = [[spawnPoint valueForKey:@"y"] floatValue];
            //printf("input: %f %f\n", x, y);
            normalEnemy2 = [[NormalEnemy2 alloc] initWithFile:@"monster-hd.png"];
            normalEnemy2.position = ccp(x, y);
            [map addChild:normalEnemy2 z:15];
            
            [normalEnemy2 animation:normalEnemy2];
            [normalEnemy2 upAndDown:normalEnemy2];
           // [self.collisionEnemies addObject:normalEnemy];
            
        }

        
        //////////////////////////// add attack enemy //////////////////////////////////
        spawnPoint = [attackEnemyObjectGroup objectNamed:@"attackEnemySpawn"];
        for(spawnPoint in [attackEnemyObjectGroup objects]){
            float x = [[spawnPoint valueForKey:@"x"] floatValue];
            float y = [[spawnPoint valueForKey:@"y"] floatValue];
            //printf("input: %f %f\n", x, y);
            attackEnemy = [[AttackEnemy alloc] initWithFile:@"monster-hd.png"];
            attackEnemy.position = ccp(x, y);
            [map addChild:attackEnemy z:14];
            [self.attackEnemies addObject:attackEnemy];
            
            [attackEnemy animation:attackEnemy];
        }
        
        ////////////////////////////initiate coin nums//////////////////////////////////
        accButtonSprite = nil;
        buttonExist = false;
        numCollected = 0;
        remainingCoins = 0;
        numAcc = 0;
        /////////////////////////////////////////////////////
        
        [self schedule:@selector(update:)];
        [self schedule:@selector(secondUpdate:) interval:2.0f];  // use different time interval for shooting projectiles.
        [self schedule:@selector(thirdUpdate:) interval:4.0f];

	}
	return self;
}

-(void)update:(ccTime)dt {
    if (gameOver) {
        return;
    }
    
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
    
    [player update:dt];
    //[followEnemy moveForward:followEnemy];
    [self handleEnemyCollisions:player];
    [self handleProjectileCollisions:player];
    [self handleCoinCollisions:player];
    [self checkForWin];
    [self checkForAndResolveCollisions:player];
    //[self handleHazardCollisions:player];
    [self setViewpointCenter:player.position];
    [self updateAccNum];
     _statusLabel.string = [NSString stringWithFormat:@"Points: %d", numAcc];
}

-(void)secondUpdate:(ccTime)dt {
    for (AttackEnemy *enemy in self.attackEnemies){
        [self shootPlayer:enemy];
    }
    for (FollowEnemy *enemy in self.followingEnemies){
        [self shootPlayerFromFollower:enemy];
    }
}

-(void)thirdUpdate:(ccTime)dt {
    //
    
    
    [followEnemy animation:followEnemy];
    [followEnemy followPlayer:player.position byitself:followEnemy];
    [player playerRunAnimation:player];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////// Coins Function Start ///////////////////////////////////////////
-(void)updateAccNum {
    if(remainingCoins > 5) {
        remainingCoins -= 5;
        numAcc ++;
    }
    if(numAcc > 0 && !buttonExist)  [self addButton];
    else if(numAcc == 0 && buttonExist) {
        [self removeButton];
    }
}

-(void)addButton {
    accButtonSprite = [CCSprite spriteWithFile:@"candy.png"];
    [self addChild:accButtonSprite];
    accButtonSprite.position = ccp(50, 100);
    buttonExist = true;
}

-(void)removeButton {
    [self removeChild:accButtonSprite cleanup:YES];
    [map removeChild:accButtonSprite cleanup:YES];
    accButtonSprite = nil;
    buttonExist = false;
}

-(Boolean)checkAccButton: (CGPoint)t {
    if((t.x - 50) * (t.x - 50) + (t.y - 100) * (t.x - 100) < 10000) return true;
    return false;
}

/////////////////////////////////////////// Coins Function End ///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////




-(void)shootPlayer:(AttackEnemy *)e {
    
    Projectile *projectile = [[Projectile alloc] initWithFile:@"ngp005.png"];
    projectile.position = ccp(e.position.x-30,e.position.y-10);
    [map addChild:projectile z:14];
    [self.projectiles addObject:projectile];

    //printf("enemy: %f  %f   player: %f  %f\n", e.position.x, e.position.y, player.position.x, player.position.y);

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

-(void)shootPlayerFromFollower:(FollowEnemy *)e {
    
    Projectile *projectile = [[Projectile alloc] initWithFile:@"P05.png"];
    int x1 = e.position.x +40;
    int y1 = e.position.y-10;
    
    
    projectile.position= ccp(x1,y1);
    [map addChild:projectile z:14];
    [self.followingProjectiles addObject:projectile];
    
    //printf("enemy: %f  %f   player: %f  %f\n", e.position.x, e.position.y, player.position.x, player.position.y);
    
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


-(void)handleHazardCollisions:(Player *)p {
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:hazards ];
    for (NSDictionary *dic in tiles) {
        CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], (map.tileSize.width / CC_CONTENT_SCALE_FACTOR()), (map.tileSize.height / CC_CONTENT_SCALE_FACTOR()));
        CGRect pRect = [p collisionBoundingBox];
        
        if ([[dic objectForKey:@"gid"] intValue] && CGRectIntersectsRect(pRect, tileRect)) {
            [self gameOver:0];
        }
    }
}

-(void)handleCoinCollisions:(Player *)p {
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:coins ];
    for (NSDictionary *dic in tiles) {
        CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], map.tileSize.width, map.tileSize.height);
        CGRect pRect = [p collisionBoundingBox];
        
        if ([[dic objectForKey:@"gid"] intValue] && CGRectIntersectsRect(pRect, tileRect)) {
        }
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
        if (CGRectIntersectsRect(pRect, eRect)) {
            [self gameOver:0];
        }
    }
}

-(void)handleProjectileCollisions:(Player *)p {
    
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
        }
    }
    for (CCSprite *projectile in self.followingProjectiles){
        CGRect eRect = CGRectMake(
                                  projectile.position.x - (projectile.contentSize.width/2),
                                  projectile.position.y - (projectile.contentSize.height/2),
                                  projectile.contentSize.width,
                                  projectile.contentSize.height);
        if (CGRectIntersectsRect(pRect, eRect)) {
            [projectilesToDelete addObject:projectile];
        }
    }
    
    
    for (CCSprite *projectile in projectilesToDelete){
        [self.projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
        [map removeChild:projectile cleanup:YES];
    }
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        CGPoint touchLocation = [self convertTouchToNodeSpace:t];
        if (touchLocation.x > 240) {
            player.mightAsWellJump = YES;
        }
        else if([self checkAccButton : touchLocation]) {
            if(numAcc >0 && !player.speedyRun) {
                //player.speedyRun = YES;
                numAcc --;
            }
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        
        CGPoint touchLocation = [self convertTouchToNodeSpace:t];
        
        //get previous touch and convert it to node space
        CGPoint previousTouchLocation = [t previousLocationInView:[t view]];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        previousTouchLocation = ccp(previousTouchLocation.x, screenSize.height - previousTouchLocation.y);
        
        if (touchLocation.x > 240 && previousTouchLocation.x <= 240) {
            player.forwardMarch = NO;
            player.mightAsWellJump = YES;
        } else if (previousTouchLocation.x > 240 && touchLocation.x <=240) {
            player.forwardMarch = YES;
            player.mightAsWellJump = NO;
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *t in touches) {
        CGPoint touchLocation = [self convertTouchToNodeSpace:t];
        if (touchLocation.x < 240) {
            player.forwardMarch = NO;
        } else {
            player.mightAsWellJump = NO;
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
        [[SimpleAudioEngine sharedEngine] playEffect:@"hurt.wav"];
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
    CGPoint tileCoord = [self tileCoordForPosition:p.position];
    int tileGid = [coins tileGIDAt:tileCoord];
    NSDictionary *properties = [map propertiesForGID:tileGid];
    NSString *collectable = [properties valueForKey:@"Collectable"];
    if (collectable && [collectable compare:@"True"] == NSOrderedSame) {
        [coins removeTileAt:tileCoord];
        self->numCollected++;
        self->remainingCoins ++;
    }
    p.position = p.desiredPosition; //8
}


@end
