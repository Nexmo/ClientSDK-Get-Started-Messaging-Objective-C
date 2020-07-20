//
//  User.h
//  GettingStarted
//
//  Created by Paul Ardeleanu on 12/09/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

#import <Foundation/Foundation.h>



#define kAliceName @"Alice"
#define kAliceUUID @"" //TODO: swap with a user uuid for Alice
#define kAliceJWT @"" //TODO: swap with a token for Alice


#define kBobName @"Bob"
#define kBobUUID @"" //TODO: swap with a user uuid for Bob
#define kBobJWT @"" //TODO: swap with a token for Bob


#define kConversationUUID @"" //TODO: swap with a phone number to call




@interface User : NSObject
@property NSString *name;
@property NSString *uuid;
@property NSString *jwt;
@property NSString *interlocutor;

-(instancetype)initWithName:(NSString *)name uuid:(NSString *)uuid jwt:(NSString *)jwt interlocutor:(NSString *)interlocutor;

+(instancetype)Alice;
+(instancetype)Bob;
@end

