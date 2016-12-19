//
//  ChatScreenController.h
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 18.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageVO.h"
#import "MainUserVO.h"

@interface ChatScreenController : UITableViewController

@property (strong, nonatomic) NSMutableArray <MessageVO*> *messageVO;
@property (strong, nonatomic) MainUserVO* mainUser;

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) UIImage *authorAvatar;
@property (strong, nonatomic) UIImage *friendAvatar;


- (void)filingMessagesVOWithCount:(NSUInteger)count
                        andOffset:(NSUInteger)offset
                           userID:(NSString *)userID
                       needRemove:(BOOL)needRemove;

@end
