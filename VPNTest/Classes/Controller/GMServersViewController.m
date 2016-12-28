//
//  GMServersViewController.m
//  VPNTest
//
//  Created by Георгий Малюков on 22.12.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "GMServersViewController.h"
#import "GMFormat.h"
#import "GMVPNServerList.h"
#import "GMEditServerViewController.h"


@interface GMServersViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation GMServersViewController


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
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        ((GMEditServerViewController *)segue.destinationViewController).server = [GMVPNServerList instance].servers[path.row];
    }
}

@end
