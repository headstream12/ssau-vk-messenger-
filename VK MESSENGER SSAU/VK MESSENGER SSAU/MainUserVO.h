//
//  MainUserVO.h
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 11.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MainUserVO : NSObject

typedef void(^CompletionHandlerMainUser)(BOOL success);

@property (strong, nonatomic) UIImage *avatarMainUser;
@property (strong, nonatomic) NSString *nameMainUser;

+ (MainUserVO *)getMainUser:(CompletionHandlerMainUser)completionHandler;

@end
