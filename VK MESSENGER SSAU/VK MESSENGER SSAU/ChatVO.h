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
typedef void(^Handler)(BOOL success);


@interface ChatVO : NSObject

@property (strong, nonatomic) NSString *nameString;
@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *messageString;
@property (strong, nonatomic) UIImage *avatarDialog;
@property (strong, nonatomic) UIImage *avatarMainUser;
@property (assign, nonatomic) BOOL isOnline;
@property (assign, nonatomic) BOOL isSending;
@property (assign, nonatomic) BOOL readState;
@property (assign, nonatomic) BOOL isMobile;



+ (void)loadListDialogsWithCount:(NSUInteger)count
                       andOffset:(NSUInteger)offset
                 completionBlock:(CompletionHandler)completionHandler;

@end
