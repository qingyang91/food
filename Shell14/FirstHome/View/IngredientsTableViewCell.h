//
//  IngredientsTableViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/23.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IngredientsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dosageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineIma;


@end

NS_ASSUME_NONNULL_END
