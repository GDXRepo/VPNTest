//
//  UIViewController+Alert.m
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "UIViewController+Alert.h"
#import "GMFormat.h"


@implementation UIViewController (Alert)


- (void)showErrorWithMessage:(NSString *)message {
    UIAlertController *ctrl = [UIAlertController
                               alertControllerWithTitle:loc(@"utils.error")
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK = [UIAlertAction
                               actionWithTitle:loc(@"utils.ok")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [ctrl dismissViewControllerAnimated:YES completion:nil];
                               }];
    [ctrl addAction:actionOK];
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)showConfirmWithTitle:(NSString *)title
                     message:(NSString *)message
                     success:(dispatch_block_t)success
                     failure:(dispatch_block_t)failure {
    UIAlertController *ctrl = [UIAlertController
                               alertControllerWithTitle:title
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK = [UIAlertAction
                               actionWithTitle:loc(@"utils.ok")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [ctrl dismissViewControllerAnimated:YES completion:nil];
                                   
                                   if (success) {
                                       success();
                                   }
                               }];
    UIAlertAction *actionCancel = [UIAlertAction
                                   actionWithTitle:loc(@"utils.cancel")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       [ctrl dismissViewControllerAnimated:YES completion:nil];
                                       
                                       if (failure) {
                                           failure();
                                       }
                                   }];
    [ctrl addAction:actionOK];
    [ctrl addAction:actionCancel];
    [self presentViewController:ctrl animated:YES completion:nil];
}

@end
