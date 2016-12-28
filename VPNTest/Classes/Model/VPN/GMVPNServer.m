//
//  GMVPNServer.m
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "GMVPNServer.h"
#import "SAMKeychain.h"
#import "GMGlobals.h"

NSString *const GMVPNServerKeyName = @"name";
NSString *const GMVPNServerKeyAddress = @"address";
NSString *const GMVPNServerKeyRemoteId = @"remoteId";


@implementation GMVPNServer


#pragma mark - Properties

- (NSString *)keychainService {
    return [@"keychain.vpn." stringByAppendingString:self.name];
}

- (NSData *)keychainPasswordReference {
    return [SAMKeychain passwordDataForService:self.keychainService account:GMGlobalsKeychainAccount];
}

- (void)setPassword:(NSString *)password {
    [SAMKeychain setPassword:password forService:self.keychainService account:GMGlobalsKeychainAccount];
}

- (NSString *)password {
    if (!self.name) {
        return nil;
    }
    return [SAMKeychain passwordForService:self.keychainService account:GMGlobalsKeychainAccount];
}


#pragma mark - Utils

- (BOOL)isEqualToServer:(GMVPNServer *)server {
    return [self.address isEqualToString:server.address];
}


#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"VPN Server '%@'. Host = %@, remoteId = %@",
            self.name,
            self.address,
            self.remoteId];
}


#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:GMVPNServerKeyName];
        self.address = [aDecoder decodeObjectForKey:GMVPNServerKeyAddress];
        self.remoteId = [aDecoder decodeObjectForKey:GMVPNServerKeyRemoteId];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:GMVPNServerKeyName];
    [aCoder encodeObject:self.address forKey:GMVPNServerKeyAddress];
    [aCoder encodeObject:self.remoteId forKey:GMVPNServerKeyRemoteId];
}

@end
