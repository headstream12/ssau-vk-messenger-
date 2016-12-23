//
//  MessageVO.m
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 18.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import "MessageVO.h"
#import <VK_ios_sdk/VKSdk.h>


@implementation MessageVO

+ (void)loadListMessagesWithCount:(NSUInteger)count
                        andOffset:(NSUInteger)offset
                           userID:(NSString *)userID
                  completionBlock:(CompletionHandler)completionHandler
{
    NSNumber *intNumberCount = [NSNumber numberWithUnsignedInteger:count];
    NSNumber *intNumberOffset = [NSNumber numberWithUnsignedInteger:offset];

    
    NSDictionary *parameters = @{@"offset":intNumberOffset,
                                 @"count":intNumberCount,
                               @"user_id":userID,
                               @"peer_id":userID,
                                   @"rev":@0 };
    
    VKRequest * requestDialogs = [VKRequest requestWithMethod:@"messages.getHistory" parameters:parameters];
    
    [requestDialogs executeWithResultBlock:^(VKResponse *response) {
        NSMutableArray *dialogsArray = [[NSMutableArray alloc] init];
        NSData *jsonSer = [NSJSONSerialization dataWithJSONObject:response.json options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonSer options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict = %@", dict);
        NSArray *items = [dict objectForKey:@"items"];
        for (NSDictionary *item in items) {
            MessageVO *messageVO = [[MessageVO alloc] init];
            
            messageVO.message = item[@"body"];
            
            NSNumber *isSendingNumber = item[@"out"];
            messageVO.isSending = isSendingNumber.boolValue;
            NSNumber *readStateNumber = item[@"read_state"];
            
            messageVO.readState = readStateNumber.boolValue;
            NSNumber *timeInterval = item[@"date"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval.doubleValue];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *stringDate = [dateFormatter stringFromDate:date];
            messageVO.date = stringDate;
            
            NSLog(@"message:= %@ ", messageVO.message);
            [dialogsArray addObject:messageVO];
            
        }
        if (completionHandler) {
            completionHandler(dialogsArray, YES);
        }
    } errorBlock:^(NSError *error) {
        if (error.code != VK_API_ERROR) {
            [error.vkError.request repeat];
        }
        else {
            NSLog(@"VK error: %@", error);
            completionHandler(nil, NO);
        }
    }];

}


@end
