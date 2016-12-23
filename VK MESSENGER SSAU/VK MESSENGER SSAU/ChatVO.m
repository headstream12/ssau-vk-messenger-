//
//  ChatVO.m
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 10.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import "ChatVO.h"
#import "MainUserVO.h"
#import <VK_ios_sdk/VKSdk.h>

@interface ChatVO ()

@end

@implementation ChatVO

+ (void)loadListDialogsWithCount:(NSUInteger)count
                       andOffset:(NSUInteger)offset
                 completionBlock:(CompletionHandler)completionHandler
{
    MainUserVO *mainUser = [MainUserVO getMainUser:^(BOOL success) {
        if (success) {
            NSNumber *intNumberCount = [NSNumber numberWithUnsignedInteger:count];
            NSNumber *intNumberOffset = [NSNumber numberWithUnsignedInteger:offset];
            NSDictionary *parameters = @{@"count":intNumberCount,
                                         @"preview_length":@50,
                                         @"offset":intNumberOffset};
            
            VKRequest * requestDialogs = [VKRequest requestWithMethod:@"messages.getDialogs" parameters:parameters];
            
            [requestDialogs executeWithResultBlock:^(VKResponse * response) {
                NSLog(@"Json result: %@", response.json);
                NSMutableArray *dialogsArray = [[NSMutableArray alloc] init];
                NSData *jsonSer = [NSJSONSerialization dataWithJSONObject:response.json options:NSJSONWritingPrettyPrinted error:nil];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonSer options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dict = %@", dict);
                NSArray *items = [dict objectForKey:@"items"];
                NSMutableArray *userIDs = [[NSMutableArray alloc] init];
                for (NSDictionary *item in items) {
                    NSDictionary *message = [item objectForKey:@"message"];
                    ChatVO *chatVO = [[ChatVO alloc] init];
                    chatVO.avatarMainUser = mainUser.avatarMainUser;
                    chatVO.messageString = message[@"body"];
                    
                    NSNumber *timeInterval = message[@"date"];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval.doubleValue];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"HH:mm dd MMM"];
                    NSString *stringDate = [dateFormatter stringFromDate:date];
                    chatVO.timeString = stringDate;
                    NSNumber *isSendingNumber = message[@"out"];
                    chatVO.isSending = isSendingNumber.boolValue;
                    NSNumber *readStateNumber = message[@"read_state"];
                    chatVO.readState = readStateNumber.boolValue;
                    NSLog(@"%d", chatVO.isSending);
                    NSLog(@"%@", chatVO.timeString);
                    
                    NSNumber *userID = message[@"user_id"];
                    
                    chatVO.userID = message[@"user_id"];
                    [userIDs addObject:userID];
                    
                    [ChatVO setInfoUserWithUserID:userID andChatVO:chatVO withCompletionHandler:^(BOOL success) {
                        [dialogsArray addObject:chatVO];
                        if (dialogsArray.count == count) {
                            if (completionHandler) {
                                completionHandler(dialogsArray, YES);
                            }
                        }
                    }];
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
    }];
    
}

+ (void)setInfoUserWithUserID:(NSNumber *)userID
                    andChatVO:(ChatVO *)chatVO
        withCompletionHandler:(Handler)handler;
{
    VKRequest *requestUser = [[VKApi users] get:@{@"user_ids":userID,
                                               VK_API_FIELDS : @[@"photo_200",@"online",@"has_mobile"]}];
    [requestUser executeWithResultBlock:^(VKResponse *response) {
        NSString *firstNameString = (NSString*)[[response.json firstObject] objectForKey:@"first_name"];
        NSString *lastNameString = (NSString*)[[response.json firstObject] objectForKey:@"last_name"];
        chatVO.nameString = [NSString stringWithFormat:@"%@ %@", firstNameString, lastNameString];
        NSLog(@"%@", chatVO.nameString);
        NSURL *url = [NSURL URLWithString:[[response.json firstObject] objectForKey:@"photo_200"]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *avatarImage = [UIImage imageWithData:imageData];
        chatVO.avatarDialog = avatarImage;
        NSNumber *isOnlineNumber = [[response.json firstObject] objectForKey:@"online"];
        chatVO.isOnline = isOnlineNumber.boolValue;
        NSNumber *isMobileNumber = [[response.json firstObject] objectForKey:@"has_mobile"];
        chatVO.isMobile = isMobileNumber.boolValue;
        handler(YES);
        
    } errorBlock:^(NSError *error) {
        if (error.code != VK_API_ERROR) {
            [error.vkError.request repeat];
        }
        else {
            NSLog(@"VK error: %@", error);
            handler(NO);
        }
    }];
}

@end
