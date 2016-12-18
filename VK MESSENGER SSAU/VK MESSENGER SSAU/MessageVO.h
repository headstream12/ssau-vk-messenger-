//
//  MessageVO.h
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 18.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionHandler)(NSArray *messages, BOOL success);

@interface MessageVO : NSObject

@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) BOOL readState;
@property (assign, nonatomic) BOOL isSending;
@property (strong, nonatomic) NSString *date;

+ (void)loadListMessagesWithCount:(NSUInteger)count
                        andOffset:(NSUInteger)offset
                           userID:(NSString *)userID
                  completionBlock:(CompletionHandler)completionHandler;


@end
