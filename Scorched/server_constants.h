//
//  server_constants.h
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#define BASE_URL @"http://127.0.0.1:8000"
#define LOGIN_PATH @"/player/login/"
#define SECRET_KEY @"^&amp;d=_g7s_u--n5+x)_l+v6ao^v3@&amp;2(6&amp;)+@^82be29ovsh)7&amp;"

// server states
#define RUNNING 1
#define SHUTDOWN 2
#define SHUTTING_DOWN 3

#define SERVER_MESSAGE 4
#define CLIENT_MESSAGE 5

// game states
#define WAITING_FOR_PLAYERS 7
#define FINISHED 8
#define INCOMPLETE 9
#define GAME_SHUTTING_DOWN 10
#define GAME_SHUT_DOWN 11
#define PLAYING_GAME 12

// client states
#define CLIENT_DISCONNECTED 13
#define CLIENT_CONNECTED 14

// server to game manager message types
#define ADD_PLAYER 17

// server to client message types
#define PROMPT_ACTION 20

// client to server message types
#define CLIENT_ACK_ACTION 21
#define AUTHENTICATE 22
#define CLIENT_CHOOSE_GAME 23

#define ACTION 24
#define CLIENT_FIRED 25
#define CLIENT_PASS 26

#define GAME_STATE_CREATED 100
#define GAME_STATE_WAITING_FOR_PLAYERS 101 // not used yet
#define GAME_STATE_STARTED 102
#define GAME_STATE_INCOMPLETE 103
#define GAME_STATE_COMPLETE 104

#define GAME_TYPE_SINGLE_PLAYER 50
#define GAME_TYPE_1_ON_1 51
#define GAME_TYPE_2_ON_2 52
#define GAME_TYPE_3_ON_3 53
#define GAME_TYPE_FFA_3 54
#define GAME_TYPE_FFA_4 55

typedef enum {
    kWebSocketMessageTypeNone = 0,
    kPromptAction = PROMPT_ACTION,
    kClientAckAction = CLIENT_ACK_ACTION,
    kAuthenticate = AUTHENTICATE,
    kClientChooseGame = CLIENT_CHOOSE_GAME,
    kAction = ACTION,
    kClientFired = CLIENT_FIRED,
    kClientPass = CLIENT_PASS,    
} BMWebSocketMessageType;

typedef enum {
    kAPIMessageTypeNone = 0,
    kAPIMessageTypeLogin = 1,
} BMAPIMessageType;











