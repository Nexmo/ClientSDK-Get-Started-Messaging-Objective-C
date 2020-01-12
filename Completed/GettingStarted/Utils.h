//
//  Utils.h
//  GettingStarted
//
//  Created by Paul Ardeleanu on 10/01/2020.
//  Copyright © 2020 Nexmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NexmoClient/NexmoClient.h>


#ifndef Utils_h
#define Utils_h

NSString * _Nonnull connectionStatusDescription(NXMConnectionStatus status);
NSString * _Nonnull connectionStatusReasonDescription(NXMConnectionStatusReason reason);

#endif /* Utils_h */
