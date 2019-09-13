//
//  StepTableViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/23.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFourthModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StepTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *stepOneLabel;
@property (nonatomic, strong) UILabel *stepTwoLabel;
@property (nonatomic, strong) UILabel *stepDesLabel;
@property (nonatomic, strong) UIImageView *stepImageView;
@property (nonatomic, strong) HomeFourthModel *model;

@end

NS_ASSUME_NONNULL_END
