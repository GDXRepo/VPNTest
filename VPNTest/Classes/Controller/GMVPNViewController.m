//
//  GMVPNViewController.m
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "GMVPNViewController.h"
#import "GMFormat.h"
#import "GMVPNConnect.h"


@interface GMVPNViewController () {
    
}

@property (weak, nonatomic) IBOutlet UILabel  *hostLabel;
@property (weak, nonatomic) IBOutlet UILabel  *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;


#pragma mark - Private

- (NSString *)localizedVPNStatus;


#pragma mark - Actions

- (IBAction)connectButtonClick:(id)sender;
- (IBAction)disconnectButtonClick:(id)sender;

@end


@implementation GMVPNViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = loc(@"vpnStatus.title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // refresh current server
    [[GMVPNConnect instance] refresh];
    // load VPN info
    GMVPNServer *srv = [GMVPNConnect instance].currentServer;
    self.hostLabel.text = (srv) ? srv.address : loc(@"vpnStatus.noServer");
}


#pragma mark - GMBaseViewController

- (void)localize {
    self.statusLabel.text = [self localizedVPNStatus];
    [self.selectButton setTitle:loc(@"vpnStatus.select") forState:UIControlStateNormal];
    [self.connectButton setTitle:loc(@"vpnStatus.connect") forState:UIControlStateNormal];
    [self.disconnectButton setTitle:loc(@"vpnStatus.disconnect") forState:UIControlStateNormal];
}


#pragma mark - Private

- (NSString *)localizedVPNStatus {
    NSString *tag = @"vpnStatus.status.unknown";
    
    switch ([GMVPNConnect instance].currentStatus) {
        case NEVPNStatusInvalid: {
            tag = @"vpnStatus.status.unknown";
            break;
        }
        case NEVPNStatusDisconnected: {
            tag = @"vpnStatus.status.disconnected";
            break;
        }
        case NEVPNStatusConnecting: {
            tag = @"vpnStatus.status.connecting";
            break;
        }
        case NEVPNStatusConnected: {
            tag = @"vpnStatus.status.connected";
            break;
        }
        case NEVPNStatusReasserting: {
            tag = @"vpnStatus.status.reasserting";
            break;
        }
        case NEVPNStatusDisconnecting: {
            tag = @"vpnStatus.status.disconnecting";
            break;
        }
        default: {
            break;
        }
    }
    return loc(tag);
}


#pragma mark - Actions

- (IBAction)connectButtonClick:(id)sender {
    if (![GMVPNConnect instance].currentServer) {
        [self showErrorWithMessage:loc(@"vpnStatus.serverError")];
        return;
    }
    GMVPNConnect *conn = [GMVPNConnect instance];
    [conn connect];
    
    if (conn.lastError) {
        [self showErrorWithMessage:conn.lastError.localizedDescription];
    }
}

- (IBAction)disconnectButtonClick:(id)sender {
    if (![GMVPNConnect instance].currentServer) {
        [self showErrorWithMessage:loc(@"vpnStatus.serverError")];
        return;
    }
    GMVPNConnect *conn = [GMVPNConnect instance];
    [conn disconnect];
    
    if (conn.lastError) {
        [self showErrorWithMessage:conn.lastError.localizedDescription];
    }
}

@end
