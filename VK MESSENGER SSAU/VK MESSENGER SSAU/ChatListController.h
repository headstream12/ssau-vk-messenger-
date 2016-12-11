//
//  ChatListController.h
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 10.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatVO.h"
#import "MainUserVO.h"

@interface ChatListController : UITableViewController

@property (strong, nonatomic) NSMutableArray <ChatVO*> *chatVO;
@property (strong, nonatomic) MainUserVO* mainUser;

- (void)filingChatVOWithCount:(NSInteger)count;

@end
