//
//  BMPlayerInfo.h
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@interface BMPlayerInfo : BMModel

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *lastLogout;
@property (nonatomic, copy) NSString *lastLogin;
@property (nonatomic, copy) NSString *socialNetworkId;
@property (nonatomic, copy) NSString *sessionKey;
@property (nonatomic, copy) NSString *playerId;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, retain) NSMutableArray *devices;
@property (nonatomic, assign) int wins;
@property (nonatomic, assign) int losses;
@property (nonatomic, assign) int rating;
@property (nonatomic, assign) int xp;
@property (nonatomic, assign) int coins;

@end
