//
//  BMGameManager.h
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMHero;
@class BMPlayer;

@interface BMGameManager : NSObject

@property (nonatomic, copy) NSString *uuid; // TODO: save uuid so it doesn't change after every login
@property (nonatomic, retain) BMHero *hero;
@property (nonatomic, retain) BMPlayer *player;

+ (BMGameManager *)sharedInstance;

- (void)syncPlayerWithDictionary:(NSDictionary *)dictionary;

@end
