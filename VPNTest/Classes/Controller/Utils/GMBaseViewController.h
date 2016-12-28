//
//  GMBaseViewController.h
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"
#import "UIViewController+Alert.h"


@interface GMBaseViewController : UIViewController {
    
}

#pragma mark - Utils

- (void)hideKeyboard;
- (void)localize;

@end
