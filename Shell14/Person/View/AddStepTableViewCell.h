//
//  StepTableViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/26.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomStepTextField.h"
#import "CustomImageView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol AddStepTableViewCellDelegate;

@interface AddStepTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet CustomImageView *stepIma;
@property (weak, nonatomic) IBOutlet CustomStepTextField *stepDetailField;
@property (nonatomic, copy) NSString *imageName;

@property(nonatomic, assign) id<AddStepTableViewCellDelegate>delegate;
- (IBAction)deleteClick:(id)sender;

@end

@protocol AddStepTableViewCellDelegate <NSObject>

- (void)deleteStep:(UITableViewCell *)cell;
- (void)contentStepDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath;
- (void)contentStepImaDidChanged:(NSData *)data forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
