//
//  ChatListController.m
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 10.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import "ChatListController.h"
#import <VK_ios_sdk/VKSdk.h>
#import "ChatCell.h"

@interface ChatListController ()

@end

@implementation ChatListController

static NSString *cellIdentifier = @"cellIdentifier";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.chatVO = [[NSMutableArray alloc] init];
    [self filingChatVOWithCount:20];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *nibName = NSStringFromClass([ChatCell class]);
    UINib *nibCell = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nibCell forCellReuseIdentifier:cellIdentifier];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 43.f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatVO.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    ChatVO *chatVO = self.chatVO[indexPath.row];
    cell.messageLabel.text = chatVO.messageString;
    cell.dateLabel.text = chatVO.timeString;
    
    return cell;
}

- (void)filingChatVOWithCount:(NSInteger)count
{
    __weak ChatListController *weakself = self;
    [ChatVO loadListDialogsWithCount:20 completionBlock:^(NSArray *resultArray, BOOL success){

        if (success) {
            [weakself.chatVO addObjectsFromArray:resultArray];
            [weakself.tableView reloadData];
        }
    }];
}


@end
