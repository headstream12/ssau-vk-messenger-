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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

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

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:nibCell forCellReuseIdentifier:cellAuthorIdentifier];
    [self.tableView registerNib:nibCellFriend forCellReuseIdentifier:cellFriendIdentifier];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 39.f;

    [self.view setBackgroundColor:[UIColor colorWithRed:229.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1]];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:229.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1]];
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI);
    
    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor clearColor];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshBegan) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
//    self.activityIndicator = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:self.activityIndicator];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backButtonTapped:)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self.activityIndicator show:YES];
    
//    if (self.isEndLoad) {
//        [self filingMessagesVOWithCount:20 andOffset:0 userID:self.userID needRemove:NO CompletionHandler:nil];
//    }
}
#pragma mark - Table view data source
- (IBAction)sendButtonAction:(UIButton *)sender {
    
}

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
    cell.timeLabel.text = messageVO.date;
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    [cell setBackgroundColor:[UIColor colorWithRed:229.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1]];
    
    if (indexPath.row == self.messageVO.count - 1) {
        [self loadPage];
    }
    
    return cell;
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadPage
{
    NSInteger offset = self.messageVO.count;
    
    if (self.isEndLoad) {
        self.isEndLoad = NO;
        [self filingMessagesVOWithCount:50
                              andOffset:offset
                                 userID:self.userID
                             needRemove:NO
                      CompletionHandler:nil];
    }
}

- (void)refreshBegan
{
    [self filingMessagesVOWithCount:50
                          andOffset:0
                             userID:self.userID
                         needRemove:YES
                  CompletionHandler:^(BOOL success) {
                      [self.tableView.refreshControl endRefreshing];
                  }];
}

- (void)filingMessagesVOWithCount:(NSUInteger)count
                        andOffset:(NSUInteger)offset
                           userID:(NSString *)userID
                       needRemove:(BOOL)needRemove
                CompletionHandler:(Handler)completionHandler
{
    __weak ChatScreenController *weakself = self;
   // [self.activityIndicator show:YES];

    self.isEndLoad = NO;
    [MessageVO loadListMessagesWithCount:count andOffset:offset userID:userID completionBlock:^(NSArray *messages, BOOL success) {
        if (success) {
            if (needRemove) {
                [weakself.messageVO removeAllObjects];
            }
            [weakself.messageVO addObjectsFromArray:messages];
            [weakself.tableView reloadData];
            weakself.isEndLoad = YES;
            //[self.activityIndicator hide:YES];
            if (completionHandler) {
                completionHandler(YES);
            }
        }
    }];
}

- (void)sendMessage
{
    NSDictionary *parameters = @{@"count":intNumberCount,
                                 @"preview_length":@50,
                                 @"offset":intNumberOffset};
    
    VKRequest * requestDialogs = [VKRequest requestWithMethod:@"messages.getDialogs" parameters:parameters];

}

@end
