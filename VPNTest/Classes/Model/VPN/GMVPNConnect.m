//
//  GMVPNConnect.m
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "GMVPNConnect.h"
#import "RLog.h"

NSString *const GMVPNConnectLocalId = @"com.gmalyukov.VPNTest.localIdentifier";


@interface GMVPNConnect () {
    
}

@property (strong, nonatomic) GMVPNServer *currentServer;
@property (strong, nonatomic) NSError     *lastError;


#pragma mark - Utils

- (void)setupIPSecWithCompletion:(dispatch_block_t)completion;

@end


@implementation GMVPNConnect


#pragma mark - Root

+ (instancetype)instance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self.class alloc] initPrivate];
    });
    return instance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        RLENTRY;
    }
    return self;
}


#pragma mark - Controls

- (void)setupServer:(GMVPNServer *)server completion:(dispatch_block_t)completion {
    RLENTRY;
    // cleanup
    self.lastError = nil;
    __weak typeof(self) welf = self;
    // setup
    [self setupIPSecWithCompletion:^{
        welf.currentServer = server;
        RLINFO(@"selected the new server %@", welf.currentServer);
        
        if (completion) {
            completion();
        }
    }];
}

- (void)connect {
    // try to start
    NSError *err = nil;
    [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&err];
    self.lastError = err;
    
    if (self.lastError) {
        RLERROR(@"unable to connect to VPN. Reason: %@", self.lastError);
    }
    else {
        RLINFO(@"successfully connected to VPN %@", self.currentServer);
    }
}

- (void)disconnect {
    RLENTRY;
    [[NEVPNManager sharedManager].connection stopVPNTunnel];
}

- (void)refresh {
    RLENTRY;
    if (![[GMVPNServerList instance] serverEqualToServer:self.currentServer]) {
        self.currentServer = nil;
    }
}


#pragma mark - Utils

- (void)setupIPSecWithCompletion:(dispatch_block_t)completion {
    RLENTRY;
    __weak typeof(self) welf = self;
    NEVPNManager *manager = [NEVPNManager sharedManager];
    
    [manager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if (!error) {
            NEVPNProtocolIPSec *p = [NEVPNProtocolIPSec new];
            p.username = self.currentServer.name;
            p.passwordReference = self.currentServer.keychainPasswordReference;
            p.serverAddress = self.currentServer.address;
            p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
            p.sharedSecretReference = [GMVPNServerList instance].sharedKeychainPasswordReference;
            p.disconnectOnSleep = NO;
            
            p.localIdentifier = GMVPNConnectLocalId;
            p.remoteIdentifier = self.currentServer.remoteId;
            p.useExtendedAuthentication = YES;
            
            [manager setProtocolConfiguration:p];
            [manager setOnDemandEnabled:NO];
            [manager setLocalizedDescription:@"VPN Connection"];
            [manager setEnabled:YES];
            // save
            [manager saveToPreferencesWithCompletionHandler:^(NSError *error) {
                if (error) {
                    welf.lastError = error;
                    RLERROR(@"unable to save VPN preferences. Reason: %@", welf.lastError);
                }
                if (completion) {
                    completion();
                }
            }];
        }
        else {
            welf.lastError = error;
            RLERROR(@"unable to load VPN preferences. Reason: %@", welf.lastError);
            
            if (completion) {
                completion();
            }
        }
    }];
}


#pragma mark - Properties

- (BOOL)isConnected {
    return (self.currentStatus == NEVPNStatusConnected);
}

@end
