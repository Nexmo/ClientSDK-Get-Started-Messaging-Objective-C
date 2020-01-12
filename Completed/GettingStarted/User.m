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

+(instancetype)Jane {
    return [[User alloc] initWithName:kJaneName uuid:kJaneUUID jwt:kJaneJWT interlocutor:@"Joe"];
}

+(instancetype)Joe {
    return [[User alloc] initWithName:kJoeName uuid:kJoeUUID jwt:kJoeJWT interlocutor:@"Jane"];
}

@end
