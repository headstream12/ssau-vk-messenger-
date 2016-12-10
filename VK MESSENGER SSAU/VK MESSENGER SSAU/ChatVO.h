//
//  ChatVO.h
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 10.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CompletionHandler)(NSArray *dialogs, BOOL success);

@interface ChatVO : NSObject

@property (strong, nonatomic) NSString *nameString;
@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *messageString;
@property (strong, nonatomic) UIImage *avatarReceiver;
@property (strong, nonatomic) UIImage *avatarSender;
@property (assign, nonatomic) BOOL receiverIsOnline;
@property (assign, nonatomic) BOOL isSending;

+ (void)loadListDialogsWithCount:(NSInteger)count
                 completionBlock:(CompletionHandler)completionHandler;

@end
