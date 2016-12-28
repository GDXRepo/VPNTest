//
//  GMVPNConnect.h
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>
#import "GMVPNServerList.h"


@interface GMVPNConnect : NSObject {
    
}

@property (readonly, nonatomic) GMVPNServer *currentServer;
@property (readonly, nonatomic) NEVPNStatus currentStatus;
@property (readonly, nonatomic) NSError     *lastError;
@property (readonly, nonatomic) BOOL        isConnected;


#pragma mark - Root

+ (instancetype)instance;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


#pragma mark - Controls

- (void)setupServer:(GMVPNServer *)server completion:(dispatch_block_t)completion;
- (void)connect;
- (void)disconnect;
- (void)refresh;

@end
