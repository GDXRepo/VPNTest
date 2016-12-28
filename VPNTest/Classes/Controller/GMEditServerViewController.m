//
//  GMEditServerViewController.m
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "GMEditServerViewController.h"
#import "GMFormat.h"
#import "GMVPNServerList.h"


@interface GMEditServerViewController ()<UITextFieldDelegate> {
    BOOL isChanged;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *remoteIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton    *removeButton;


#pragma mark - Actions

- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)saveButtonClick:(id)sender;
- (IBAction)removeButtonClick:(id)sender;

@end


@implementation GMEditServerViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = loc(@"editServer.title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    isChanged = NO;
    // create new server
    if (!self.server) {
        self.server = [GMVPNServer new];
    }
    self.nameTextField.text = self.server.name;
    self.addressTextField.text = self.server.address;
    self.remoteIdTextField.text = self.server.remoteId;
    self.passwordTextField.text = self.server.password;
}

- (void)localize {
    self.nameTextField.placeholder = loc(@"editServer.vpnName");
    self.addressTextField.placeholder = loc(@"editServer.vpnHost");
    self.remoteIdTextField.placeholder = loc(@"editServer.remoteId");
    self.passwordTextField.placeholder = loc(@"editServer.password");
    [self.removeButton setTitle:loc(@"editServer.remove") forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)cancelButtonClick:(id)sender {
    if (isChanged) {
        [self
         showConfirmWithTitle:nil
         message:loc(@"editServer.confirm.discard")
         success:^{
             [self.navigationController popViewControllerAnimated:YES];
         }
         failure:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)saveButtonClick:(id)sender {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    self.server.name = [self.nameTextField.text stringByTrimmingCharactersInSet:set];
    self.server.address = [self.addressTextField.text stringByTrimmingCharactersInSet:set];
    self.server.remoteId = [self.remoteIdTextField.text stringByTrimmingCharactersInSet:set];
    self.server.password = self.passwordTextField.text;
    
    if ([self.server.name isEqualToString:@""]
        || [self.server.address isEqualToString:@""]
        || [self.server.remoteId isEqualToString:@""]
        || [self.server.password isEqualToString:@""]) {
        [self showErrorWithMessage:loc(@"editServer.fieldsError")];
    }
    else {
        [[GMVPNServerList instance] addServer:self.server];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)removeButtonClick:(id)sender {
    [self showConfirmWithTitle:nil
                       message:loc(@"editServer.confirm.remove")
                       success:^{
                           [[GMVPNServerList instance] removeServer:self.server];
                           [self.navigationController popViewControllerAnimated:YES];
                       }
                       failure:nil];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    isChanged = YES;
    return YES;
}

@end
