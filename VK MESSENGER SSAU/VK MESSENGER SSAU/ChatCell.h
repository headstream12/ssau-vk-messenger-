//
//  ChatCell.h
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 11.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
