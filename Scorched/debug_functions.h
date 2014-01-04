//
//  debug_functions.h
//  Scorched
//
//  Created by Mark Kim on 4/11/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#ifndef Scorched_debug_functions_h
#define Scorched_debug_functions_h

#import "debug_constants.h"

#define DEBUG_LOG_MODE
#ifdef DEBUG_LOG_MODE
#define debug( s, ... ) NSLog( @"%@:%d:%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define debug( s, ... )
#endif

#endif
