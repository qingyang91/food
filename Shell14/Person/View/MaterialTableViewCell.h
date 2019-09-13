//
//  MaterialTableViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/26.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MaterialTableViewCellDelegate;

@interface MaterialTableViewCell : UITableViewCell

@property (nonatomic, strong) CustomTextField *nameField;
@property (nonatomic, strong) CustomTextField *dosageField;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) id<MaterialTableViewCellDelegate>delegate;

@end

@protocol MaterialTableViewCellDelegate <NSObject>

- (void)deleteCellClick:(UITableViewCell *)cell;

- (void)contentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath;
- (void)dosageFieldContentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
