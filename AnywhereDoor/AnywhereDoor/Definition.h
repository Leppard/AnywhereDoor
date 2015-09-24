//
//  Definition.h
//  AnywhereDoor
//
//  Created by Leppard on 9/19/15.
//  Copyright © 2015 Leppard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/iflyMSC.h>

#define APPID_VALUE           @"55fd2a4b"

#define GET_LOCATION_URL      @"http://zeman.im/door/savelatestlocation.php"
#define GOTO_LOCATION_URL     @"http://zeman.im/door/changelocation.php"

#define SET_COMMAND           @"saveas"
#define GOTO_COMMAND          @"go"

#define SAVE_SUCCESS_VOICE    @"saving location succeed."
#define SAVE_FAIL_VOICE       @"sorry, saving fail."
#define JUMP_SUCCESS_VOICE    @"jumping to destination."
#define JUMP_FAIL_VOICE       @"sorry, jumping fail."
#define JUMP_NOTFOUND_VOICE   @"sorry, destination not found."
#define COMMAND_ERROR_VOICE   @"sorry, I can not recognize your command."
