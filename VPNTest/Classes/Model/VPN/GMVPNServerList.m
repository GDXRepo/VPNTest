//
//  GMVPNServerList.m
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "GMVPNServerList.h"
#import "RLog.h"
#import "GMGlobals.h"
#import "SAMKeychain.h"

NSString *const GMVPNServerListFileName = @"vpnlist.dat";
NSString *const GMVPNServerListKeychainSharedPasswordService = @"vpnlist.sharedService";


@interface GMVPNServerList () {
    NSMutableArray *_servers;
}

@property (readonly, nonatomic) NSString *filePath;

@end


@implementation GMVPNServerList

@synthesize servers = _servers;


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
        _servers = [NSMutableArray new];
        [self loadData];
    }
    return self;
}


#pragma mark - Data

- (void)loadData {
    RLENTRY;
    NSString *fpath = self.filePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:fpath]) {
        if ([fm isReadableFileAtPath:fpath]) {
            _servers = [NSKeyedUnarchiver unarchiveObjectWithFile:fpath];
            RLINFO(@"servers loaded: %ld", self.servers.count);
        }
        else {
            RLFATAL(@"unable to read file at path %@", fpath);
        }
    }
}

- (void)saveData {
    RLENTRY;    
    [NSKeyedArchiver archiveRootObject:self.servers toFile:self.filePath];
}

- (void)addServer:(GMVPNServer *)server {
    RLENTRY;
    GMVPNServer *srv = [self serverEqualToServer:server];
    
    if (srv) {
        srv = server;
    }
    else {
        [_servers addObject:server];
    }
    [self saveData];
}

- (void)removeServer:(GMVPNServer *)server {
    RLENTRY;
    GMVPNServer *srv = [self serverEqualToServer:server];
    
    if (srv) {
        [_servers removeObject:srv];
    }
    [self saveData];
}

- (GMVPNServer *)serverEqualToServer:(GMVPNServer *)server {
    RLINFO(@"looking for server %@", server);
    for (GMVPNServer *item in self.servers) {
        if ([item isEqualToServer:server]) {
            return item;
        }
    }
    return nil;
}


#pragma mark - Properties

- (NSString *)filePath {
    // no storing in any internal variable because it can be missed while app is in background mode
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES).firstObject;
    return [docsPath stringByAppendingPathComponent:GMVPNServerListFileName];
}

- (NSData *)sharedKeychainPasswordReference {
#warning TODO: This password must be saved inside a keychain once at app's launch
    return [SAMKeychain passwordDataForService:GMVPNServerListKeychainSharedPasswordService
                                       account:GMGlobalsKeychainAccount];
}

@end
