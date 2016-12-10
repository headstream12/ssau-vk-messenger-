//
//  AuthController.m
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 10.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import "AuthController.h"
#import <VK_ios_sdk/VKSdk.h>


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
//    VKRequest * req = [[VKApi users] get:@{@"fields":@"photo_50"}];
//
//    [req executeWithResultBlock:^(VKResponse * response) {
//        NSLog(@"Json result: %@", response.json);
//    } errorBlock:^(NSError * error) {
//        if (error.code != VK_API_ERROR) {
//            [error.vkError.request repeat];
//        }
//        else {
//            NSLog(@"VK error: %@", error);
//        }
//    }];
}

#pragma mark - VKSdkDelegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result
{
    NSLog(@"Authorization finished with result");
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
