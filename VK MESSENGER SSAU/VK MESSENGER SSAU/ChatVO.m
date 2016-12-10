//
//  ChatVO.m
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 10.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import "ChatVO.h"
#import <VK_ios_sdk/VKSdk.h>

@interface ChatVO ()

@end

@implementation ChatVO

+ (void)loadListDialogsWithCount:(NSInteger)count
                 completionBlock:(CompletionHandler)completionHandler
{
    NSNumber *intNumberCount = [NSNumber numberWithInteger:count];
    NSDictionary *parameters = @{@"count":intNumberCount,
                                 @"preview_length":@50};
    
    VKRequest * req = [VKRequest requestWithMethod:@"messages.getDialogs" parameters:parameters];
    
    [req executeWithResultBlock:^(VKResponse * response) {
        NSLog(@"Json result: %@", response.json);
        NSMutableArray *dialogsArray = [[NSMutableArray alloc] init];
        NSInteger offset = 1;
        NSData *jsonSer = [NSJSONSerialization dataWithJSONObject:response.json options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonSer options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict = %@", dict);
        NSArray *items = [dict objectForKey:@"items"];

        for (NSDictionary *item in items) {
            
            NSDictionary *message = [item objectForKey:@"message"];
            ChatVO *chatVO = [[ChatVO alloc] init];
            chatVO.messageString = message[@"body"];
            
            NSNumber *timeInterval = message[@"date"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval.doubleValue];
            NSString *stringDate = date.description;
            chatVO.timeString = stringDate;
            chatVO.isSending = message[@"out"];
            [dialogsArray addObject:chatVO];
            NSLog(@"%@", chatVO.messageString);
            NSLog(@"%@", chatVO.timeString);
        }
        
        
        
        if (completionHandler) {
            completionHandler(dialogsArray, YES);
        }
        
    } errorBlock:^(NSError * error) {
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
