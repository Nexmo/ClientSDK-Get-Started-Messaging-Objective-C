//
//  User.m
//  GettingStarted
//
//  Created by Paul Ardeleanu on 13/09/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWithName:(NSString *)name uuid:(NSString *)uuid jwt:(NSString *)jwt interlocutor:(NSString *)interlocutor {
    if(self = [super init]) {
        self.name = name;
        self.uuid = uuid;
        self.jwt = jwt;
        self.interlocutor = interlocutor;
    }
    return self;
}

+(instancetype)Alice {
    return [[User alloc] initWithName:kAliceName uuid:kAliceUUID jwt:kAliceJWT interlocutor:@"Bob"];
}

+(instancetype)Bob {
    return [[User alloc] initWithName:kBobName uuid:kBobUUID jwt:kBobJWT interlocutor:@"Alice"];
}

@end
