//
//  MainUserVO.m
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 11.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import "MainUserVO.h"
#import <VK_ios_sdk/VKSdk.h>

@implementation MainUserVO

+ (MainUserVO *)getMainUser:(CompletionHandlerMainUser)completionHandler
{
    MainUserVO *user = [[MainUserVO alloc] init];
    VKRequest *requestMainUser = [[VKApi users] get:@{VK_API_FIELDS : @"photo_50"}];
    
    [requestMainUser executeWithResultBlock:^(VKResponse *response) {
        NSURL *url = [NSURL URLWithString:[[response.json firstObject] objectForKey:@"photo_50"]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *avatarImage = [UIImage imageWithData:imageData];
        user.avatarMainUser = avatarImage;
        
        NSString *firstNameString = (NSString*)[[response.json firstObject] objectForKey:@"first_name"];
        NSString *lastNameString = (NSString*)[[response.json firstObject] objectForKey:@"last_name"];
        user.nameMainUser = [NSString stringWithFormat:@"%@ %@", firstNameString, lastNameString];
        if (completionHandler) {
            completionHandler(YES);
        }

    } errorBlock:^(NSError *error) {
        if (error.code != VK_API_ERROR) {
            [error.vkError.request repeat];
        }
        else {
            NSLog(@"VK error: %@", error);
            if (completionHandler) {
                completionHandler(NO);
            }
        }
    }];
    return user;
}

@end
