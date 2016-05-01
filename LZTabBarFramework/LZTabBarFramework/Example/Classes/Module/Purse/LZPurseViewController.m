//
//  LZPurseViewController.m
//  LZTabBarFramework
//
//  Created by 刘梓颖 on 16/5/1.
//  Copyright © 2016年 LZING. All rights reserved.
//

#import "LZPurseViewController.h"

@interface LZPurseViewController ()

@end

static NSString * const reuseIdentifier = @"cell";

@implementation LZPurseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"钱包";
    self.tabBarItem.title = @"钱包";
    [self.navigationController.tabBarItem setBadgeValue:@"3"];
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ Controller Cell %@", self.tabBarItem.title, @(indexPath.row)];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", @(indexPath.row + 1)]];
}

@end
