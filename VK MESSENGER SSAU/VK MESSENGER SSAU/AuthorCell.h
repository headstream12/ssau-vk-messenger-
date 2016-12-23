//
//  AuthorCell.h
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 18.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundMessageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
