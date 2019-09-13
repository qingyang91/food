//
//  MyCreationTableViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/25.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCreationTableViewCellDelegate;


@interface MyCreationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *foodIma;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) id<MyCreationTableViewCellDelegate>delegate;
- (IBAction)deleteClick:(id)sender;
- (IBAction)creditClick:(id)sender;

@end

@protocol MyCreationTableViewCellDelegate <NSObject>

- (void)deleteCreation:(UITableViewCell *)cell;
- (void)creaditCreation:(UITableViewCell *)cell;

@end

NS_ASSUME_NONNULL_END
