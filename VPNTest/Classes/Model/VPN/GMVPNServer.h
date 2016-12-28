//
//  GMVPNServer.h
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMVPNServer : NSObject<NSCoding> {
    
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *remoteId;
@property (weak, nonatomic) NSString *password;

@property (readonly, nonatomic) NSString *keychainService;
@property (readonly, nonatomic) NSData   *keychainPasswordReference;


#pragma mark - Utils

- (BOOL)isEqualToServer:(GMVPNServer *)server;

@end
