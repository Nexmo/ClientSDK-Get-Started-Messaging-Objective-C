//
//  Utils.m
//  GettingStarted
//
//  Created by Paul Ardeleanu on 10/01/2020.
//  Copyright © 2020 Nexmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NexmoClient/NexmoClient.h>
#import "Utils.h"


NSString * _Nonnull connectionStatusDescription(NXMConnectionStatus status) {
    switch (status) {

        case NXMConnectionStatusDisconnected:
            return @"Disconnected";
            break;
        case NXMConnectionStatusConnecting:
            return @"Connecting";
            break;
        case NXMConnectionStatusConnected:
            return @"Connected";
            break;
    }
}


NSString * _Nonnull connectionStatusReasonDescription(NXMConnectionStatusReason reason) {
    switch (reason) {
        case NXMConnectionStatusReasonUnknown:
            return @"Unknown";
            break;
        case NXMConnectionStatusReasonLogin:
            return @"Login";
            break;
        case NXMConnectionStatusReasonLogout:
            return @"Logout";
            break;
        case NXMConnectionStatusReasonTokenRefreshed:
            return @"Token refreshed";
            break;
        case NXMConnectionStatusReasonTokenInvalid:
            return @"Token invalid";
            break;
        case NXMConnectionStatusReasonTokenExpired:
            return @"Token expired";
            break;
        case NXMConnectionStatusReasonUserNotFound:
            return @"User not found";
            break;
        case NXMConnectionStatusReasonTerminated:
            return @"Terminated";
            break;
    }
}

