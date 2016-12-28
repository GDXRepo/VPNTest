//
//  GMVPNServerList.h
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMVPNServer.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMVPNServerList : NSObject {
    
}

@property (readonly, nonatomic) NSArray<GMVPNServer *> *servers;
@property (readonly, nonatomic) NSData *sharedKeychainPasswordReference;


#pragma mark - Root

+ (instancetype)instance;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


#pragma mark - Data

- (void)loadData;
- (void)saveData;
- (void)addServer:(GMVPNServer *)server;
- (void)removeServer:(GMVPNServer *)server;
- (GMVPNServer * _Nullable)serverEqualToServer:(GMVPNServer *)server;

@end

NS_ASSUME_NONNULL_END
