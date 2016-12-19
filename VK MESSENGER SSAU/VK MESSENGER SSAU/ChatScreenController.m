//
//  ChatScreenController.m
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 18.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import "ChatScreenController.h"
#import "AuthorCell.h"
#import "FriendCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ChatScreenController ()

@property (strong, nonatomic) MBProgressHUD *activityIndicator;
@property (assign, nonatomic) BOOL isEndLoad;

@end

@implementation ChatScreenController

static NSString *cellAuthorIdentifier = @"cellAuthorIdentifier";
static NSString *cellFriendIdentifier = @"cellFriendIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *nibName = NSStringFromClass([AuthorCell class]);
    UINib *nibCell = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
    
    NSString *nibNameFriend = NSStringFromClass([FriendCell class]);
    UINib *nibCellFriend = [UINib nibWithNibName:nibNameFriend bundle:[NSBundle mainBundle]];

    [self.tableView registerNib:nibCell forCellReuseIdentifier:cellAuthorIdentifier];
    [self.tableView registerNib:nibCellFriend forCellReuseIdentifier:cellFriendIdentifier];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 27.f;


    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI);
    
    self.activityIndicator = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.activityIndicator show:YES];
    
    if (self.isEndLoad) {
        [self filingMessagesVOWithCount:20 andOffset:0 userID:self.userID needRemove:NO];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageVO.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageVO *messageVO = self.messageVO[indexPath.row];
    NSLog(@"%@", self.messageVO[indexPath.row].message);

    AuthorCell *cell;
    if (messageVO.isSending) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellFriendIdentifier forIndexPath:indexPath];
        cell.avatarImageView.image = self.authorAvatar;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellAuthorIdentifier forIndexPath:indexPath];
        cell.avatarImageView.image = self.friendAvatar;
    }
    cell.messageLabel.text = messageVO.message;
    cell.transform = CGAffineTransformMakeRotation(M_PI);

    return cell;
}


- (void)filingMessagesVOWithCount:(NSUInteger)count
                        andOffset:(NSUInteger)offset
                           userID:(NSString *)userID
                       needRemove:(BOOL)needRemove
{
    __weak ChatScreenController *weakself = self;
    [self.activityIndicator show:YES];

    self.isEndLoad = NO;
    [MessageVO loadListMessagesWithCount:count andOffset:offset userID:userID completionBlock:^(NSArray *messages, BOOL success) {
        if (success) {
            if (needRemove) {
                [weakself.messageVO removeAllObjects];
            }
            [weakself.messageVO addObjectsFromArray:messages];
            [weakself.tableView reloadData];
            self.isEndLoad = YES;
            [self.activityIndicator hide:YES];

        }
    }];
}

@end
