//
//  BMHealthBar.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"

@interface BMHealthBar : BMViewModel

@property (nonatomic, assign) id<BMHealthBarDelegate> delegate;
@property (nonatomic, retain) CCSprite *backSprite;
@property (nonatomic, retain) CCSprite *frontSprite;

- (void)updateView;

- (id)initWithDelegate:(id<BMHealthBarDelegate>)delegate;
- (id)initWithDelegate:(id<BMHealthBarDelegate>)delegate
            backSprite:(CCSprite *)backSprite
           frontSprite:(CCSprite *)frontSprite;

@end
