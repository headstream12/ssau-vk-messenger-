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
#import <MBProgressHUD/MBProgressHUD.h>

@interface ChatListController ()

@property (strong, nonatomic) MBProgressHUD *activityIndicator;

@end

@implementation ChatListController

static NSString *cellIdentifier = @"cellIdentifier";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.chatVO = [[NSMutableArray alloc] init];
    [self filingChatVOWithCount:20];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *nibName = NSStringFromClass([ChatCell class]);
    UINib *nibCell = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nibCell forCellReuseIdentifier:cellIdentifier];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 71.f;
    self.navigationItem.title = self.mainUser.nameMainUser;
    
    self.activityIndicator = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.activityIndicator show:YES];
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
    [self configureCell:cell withChatVO:chatVO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ChatCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatVO *chatVO = self.chatVO[indexPath.row];
    if (!chatVO.isSending) {
        [cell.youLabel setHidden:YES];
        cell.messageConstraint.constant = 8;
    } else {
        [cell.youLabel setHidden:NO];
        cell.messageConstraint.constant = 37;
    }
    cell.avatarView.image = chatVO.avatarDialog;
    cell.avatarView.layer.cornerRadius = 29.f;
    cell.avatarView.clipsToBounds = YES;
    UIView *backView = [[UIView alloc] init];
    
    if (!chatVO.readState && !chatVO.isSending) {
        [cell.readStateView setBackgroundColor:[UIColor clearColor]];
        [backView setBackgroundColor:[UIColor colorWithHex:0xE5EBF0]];//E7EDF3
    }
    if (chatVO.readState) {
        [backView setBackgroundColor:[UIColor whiteColor]];
        [cell.readStateView setBackgroundColor:[UIColor whiteColor]];
    }
    if (!chatVO.readState && chatVO.isSending) {
        [cell.readStateView setBackgroundColor:[UIColor colorWithHex:0xE5EBF0]];
        [backView setBackgroundColor:[UIColor whiteColor]];
    }
    [cell setBackgroundView:backView];
    
    if (chatVO.isOnline && chatVO.isMobile) {
        [cell.onlineImage setHidden:NO];
        cell.onlineImage.image = [UIImage imageNamed:@"mobile.png"];
    }
    if (!chatVO.isOnline) {
        [cell.onlineImage setHidden:YES];
    }
    
}

- (void)configureCell:(ChatCell *)cell
           withChatVO:(ChatVO *)chatVO
{
    cell.messageLabel.text = chatVO.messageString;
    cell.dateLabel.text = chatVO.timeString;
    cell.nameLabel.text = chatVO.nameString;
//    if (!chatVO.isSending) {
//        [cell.youLabel setHidden:YES];
//        cell.messageConstraint.constant = 8;
//    } else {
//        [cell.youLabel setHidden:NO];
//        cell.messageConstraint.constant = 37;
//    }
//    cell.avatarView.image = chatVO.avatarDialog;
//    cell.avatarView.layer.cornerRadius = 29.f;
//    cell.avatarView.clipsToBounds = YES;
//    UIView *backView = [[UIView alloc] init];
//
//    if (!chatVO.readState && !chatVO.isSending) {
//        [cell.readStateView setBackgroundColor:[UIColor clearColor]];
//        [backView setBackgroundColor:[UIColor colorWithHex:0xE5EBF0]];//E7EDF3
//    }
//    if (chatVO.readState) {
//        [backView setBackgroundColor:[UIColor whiteColor]];
//        [cell.readStateView setBackgroundColor:[UIColor whiteColor]];
//    }
//    if (!chatVO.readState && chatVO.isSending) {
//        [cell.readStateView setBackgroundColor:[UIColor colorWithHex:0xE5EBF0]];
//        [backView setBackgroundColor:[UIColor whiteColor]];
//    }
//    [cell setBackgroundView:backView];
}

- (void)filingChatVOWithCount:(NSInteger)count
{
    [self.activityIndicator show:YES];
    __weak ChatListController *weakself = self;
    [ChatVO loadListDialogsWithCount:20 completionBlock:^(NSArray *resultArray, BOOL success){

        if (success) {
            [weakself.chatVO addObjectsFromArray:resultArray];
            [weakself.tableView reloadData];
            [self.activityIndicator hide:YES];
        }
    }];
}


@end
