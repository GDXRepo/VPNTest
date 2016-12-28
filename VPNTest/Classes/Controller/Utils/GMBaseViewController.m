//
//  GMBaseViewController.m
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "GMBaseViewController.h"


@interface GMBaseViewController () {
    
}

@end


@implementation GMBaseViewController


#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self localize];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Utils

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)localize {
    // empty
}

@end
