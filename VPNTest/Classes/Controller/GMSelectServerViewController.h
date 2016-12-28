//
//  GMSelectServerViewController.h
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMVPNServer.h"


@interface GMSelectServerViewController : UITableViewController {
    
}

@property (strong, nonatomic) GMVPNServer *server;

@end
