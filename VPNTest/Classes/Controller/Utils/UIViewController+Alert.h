//
//  UIViewController+Alert.h
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (Alert)

- (void)showErrorWithMessage:(NSString *)message;
- (void)showConfirmWithTitle:(NSString *)title
                     message:(NSString *)message
                     success:(dispatch_block_t)success
                     failure:(dispatch_block_t)failure;

@end
