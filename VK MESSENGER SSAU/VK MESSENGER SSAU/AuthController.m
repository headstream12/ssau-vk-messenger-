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
#import "Session.h"
#import "EHFAuthenticator.h"

typedef void(^HandlerSuccess)(void);

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
    [VKSdk authorize:@[VK_PER_PHOTOS,VK_PER_MESSAGES]];
}

#pragma mark - VKSdkDelegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result
{
    NSLog(@"Authorization finished with result");
    
    if (result.token.accessToken) {

        
        ChatListController *listController = [[ChatListController alloc] init];
        listController.chatVO = [[NSMutableArray alloc] init];
        [listController filingChatVOWithCount:20 andOffset:0 needRemove:NO];
        listController.mainUser = [MainUserVO getMainUser:^(BOOL success) {
            if (success) {
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:listController];
            
                [self presentViewController:navController animated:YES completion:nil];
            }
        }];
        
        
    }
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

-(void) presentAlertControllerWithMessage:(NSString *) message withSuccessHandler:(HandlerSuccess)handler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Touch ID" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:handler];
}
@end
