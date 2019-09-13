//
//  FoodDetailViewController.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/22.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "QMUICommonViewController.h"
#import "HomeFourthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FoodDetailViewController : QMUICommonViewController

@property (nonatomic, strong) HomeFourthModel *model;
@property (nonatomic, strong) MyCreationModel *creationModel;

@end

NS_ASSUME_NONNULL_END
