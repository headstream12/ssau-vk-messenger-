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
#import "ChatScreenController.h"
#import "EHFAuthenticator.h"

@class AuthController;

@interface ChatListController ()

@property (strong, nonatomic) MBProgressHUD *activityIndicator;
@property (assign, nonatomic) BOOL isEndLoad;
@property (assign, nonatomic) BOOL isFirstLoad;
@property (strong, nonatomic) UIView *viewHide;

@end

@implementation ChatListController

static NSString *cellIdentifier = @"cellIdentifier";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.chatVO = [[NSMutableArray alloc] init];
    [self filingChatVOWithCount:20 andOffset:0 needRemove:NO];
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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshBegan) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:80.f/255.0f green:114.f/255.0f blue:153/255.0f alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.tableView.tableFooterView = [UIView new];
    self.isFirstLoad = YES;
    
    self.tableView.hidden = YES;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"exit"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(exitButtonTapped:)];
    rightItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:rightItem];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isFirstLoad) {
        [self.activityIndicator show:YES];
        self.isFirstLoad = NO;
        [[EHFAuthenticator sharedInstance] setReason:@"Подтвердите личность с помощью Touch ID"];
        [[EHFAuthenticator sharedInstance] authenticateWithSuccess:^(){
            [self presentAlertControllerWithMessage:@"Личность подтверждена"];
            self.tableView.hidden = NO;
            
            
        } andFailure:^(LAError errorCode){
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];

    }
}

- (void)exitButtonTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [VKSdk forceLogout];
    }];
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
    
    if (indexPath.row == self.chatVO.count - 1) {
        [self loadPage];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ChatScreenController *chatScreenController = [[ChatScreenController alloc] init];
    ChatVO *chatVO = self.chatVO[indexPath.row];
//    chatScreenController.userID = chatVO.userID;
//    chatScreenController.friendAvatar = chatVO.avatarDialog;
//    chatScreenController.authorAvatar = chatVO.avatarMainUser;
//    chatScreenController.messageVO = [[NSMutableArray alloc] init];
//    [chatScreenController filingMessagesVOWithCount:20 andOffset:0 userID:chatVO.userID needRemove:NO];
//    [self.navigationController pushViewController:chatScreenController animated:YES];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatScreenController *controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ChatScreenController"];
    controller.userID = chatVO.userID;
    controller.friendAvatar = chatVO.avatarDialog;
    controller.authorAvatar = chatVO.avatarMainUser;
    controller.messageVO = [[NSMutableArray alloc] init];
    
    controller.title = chatVO.nameString;
    [controller filingMessagesVOWithCount:50 andOffset:0 userID:controller.userID needRemove:NO CompletionHandler:^(BOOL success) {
        if (success) {
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

- (void)loadPage
{
    NSInteger offset = self.chatVO.count;
    
    if (self.isEndLoad) {
        self.isEndLoad = NO;
        [self filingChatVOWithCount:20 andOffset:offset needRemove:NO];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ChatCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatVO *chatVO = self.chatVO[indexPath.row];
    if (!chatVO.isSending) {
        [cell.youLabel setHidden:YES];
        cell.messageConstraint.constant = 10;
    } else {
        [cell.youLabel setHidden:NO];
        cell.messageConstraint.constant = 37;
    }
    cell.avatarView.image = chatVO.avatarDialog;
    cell.avatarView.layer.cornerRadius = 35.f;
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
}

- (void)refreshBegan
{
    [self filingChatVOWithCount:20 andOffset:0 needRemove:YES];
}

- (void)filingChatVOWithCount:(NSUInteger)count
                    andOffset:(NSUInteger)offset
                   needRemove:(BOOL)needRemove
{
    [self.activityIndicator show:YES];
    
    __weak ChatListController *weakself = self;
    self.isEndLoad = NO;
    [ChatVO loadListDialogsWithCount:count andOffset:offset completionBlock:^(NSArray *resultArray, BOOL success){

        if (success) {
            if (needRemove) {
                [weakself.chatVO removeAllObjects];
            }
            [weakself.chatVO addObjectsFromArray:resultArray];
            [weakself.tableView reloadData];
            [weakself.activityIndicator hide:YES];
            weakself.isEndLoad = YES;
            [weakself.refreshControl endRefreshing];

        }
    }];
}

-(void) presentAlertControllerWithMessage:(NSString *) message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Touch ID" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
