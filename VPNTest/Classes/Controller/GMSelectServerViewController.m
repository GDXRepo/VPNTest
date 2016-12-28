//
//  GMSelectServerViewController.m
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "GMSelectServerViewController.h"
#import "GMFormat.h"
#import "GMVPNConnect.h"
#import "MBProgressHUD.h"
#import "UIViewController+Alert.h"


@interface GMSelectServerViewController () {
    
}

@end


@implementation GMSelectServerViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = loc(@"serversList.title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GMVPNServerList instance].servers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"CellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.textLabel.text = [GMVPNServerList instance].servers[indexPath.row].name;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [[GMVPNConnect instance]
     setupServer:[GMVPNServerList instance].servers[indexPath.row]
     completion:^{
         [hud hideAnimated:YES];
         
         NSError *err = [GMVPNConnect instance].lastError;
         
         if (err) {
             [self showErrorWithMessage:err.localizedDescription];
         }
         else {
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

@end
