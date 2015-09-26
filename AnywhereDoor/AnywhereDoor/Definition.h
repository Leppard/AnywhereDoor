//
//  Definition.h
//  AnywhereDoor
//
//  Created by Leppard on 9/19/15.
//  Copyright © 2015 Leppard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/iflyMSC.h>

#define APPID_VALUE             @"55fd2a4b"

#define GET_LOCATION_URL        @"http://zeman.im/door/savelatestlocation.php"
#define GOTO_LOCATION_URL       @"http://zeman.im/door/changelocation.php"
#define SET_WEATHER_URL         @"http://zeman.im/door/changeweather.php"
#define SET_TIME_URL            @"http://zeman.im/door/changetime.php"
#define PFLOW_URL               @"http://zeman.im/door/changepeopleflow.php"
#define TFLOW_URL               @"http://zeman.im/door/changetrafficflow.php"

#define SET_COMMAND             @"saveas"
#define GOTO_COMMAND            @"go"
#define WEATHER_COMMAND         @"setweather"
#define TIME_COMMAND            @"settime"
#define PFLOW_COMMAND           @"peopleflow"
#define TFLOW_COMMAND           @"trafficflow"

#define SAVE_SUCCESS_VOICE      @"saving location succeed."
#define NETWORK_FAIL_VOICE      @"sorry, networking failed."
#define JUMP_SUCCESS_VOICE      @"jumped to destination."
#define JUMP_NOTFOUND_VOICE     @"sorry, destination not found."
#define COMMAND_ERROR_VOICE     @"sorry, I can not recognize your command."
#define WEATHER_NOTFOUND_VOICE  @"sorry, this weather is not allowed."
#define WEATHER_SUCCESS_VOICE   @"weather changed."
#define TIME_NOTFOUND_VOICE     @"sorry, this time is not allowed."
#define TIME_SUCCESS_VOICE      @"time changed."
#define STATUS_NOTFOUND_VOICE   @"sorry, status is not correct."
#define PFLOW_SUCESS_VOICE      @"people flow status changed."
#define TFLOW_SUCESS_VOICE      @"traffic flow status changed."
