//
//  AuthController.m
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 10.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import "AuthController.h"
#import <VK_ios_sdk/VKSdk.h>
#import "ChatListController.h"
#import "MainUserVO.h"


@interface AuthController () <VKSdkDelegate, VKSdkUIDelegate>

@property (assign, nonatomic) BOOL autorized;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
 
@end

@implementation AuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    VKSdk *vkSdk = [VKSdk initializeWithAppId:@"5721364"];
    
    [vkSdk registerDelegate:self];
    [vkSdk setUiDelegate:self];
    
    self.autorized = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)authAction:(UIButton *)sender {
    if (!self.autorized) {
        [VKSdk authorize:@[VK_PER_PHOTOS,VK_PER_MESSAGES]];
    }
}

#pragma mark - VKSdkDelegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result
{
    NSLog(@"Authorization finished with result");
    VKRequest * req = [[VKApi users] get:@{@"fields":@"photo_200"}];
    
    [req executeWithResultBlock:^(VKResponse * response) {
        
        ChatListController *listController = [[ChatListController alloc] init];
        listController.chatVO = [[NSMutableArray alloc] init];
        [listController filingChatVOWithCount:20 andOffset:0 needRemove:NO];
        listController.mainUser = [MainUserVO getMainUser:^(BOOL success) {
            if (success) {
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:listController];
                
                [self presentViewController:navController animated:YES completion:nil];
            }
        }];
        
        
        
    } errorBlock:^(NSError * error) {
        if (error.code != VK_API_ERROR) {
            [error.vkError.request repeat];
        }
        else {
            NSLog(@"VK error: %@", error);
        }
    }];

}

- (void)vkSdkUserAuthorizationFailed
{
    NSLog(@"ErrorAuth");
}

#pragma mark - VKSdkUIDelegate

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkDidDismissViewController:(UIViewController *)controller
{
    
}

@end
