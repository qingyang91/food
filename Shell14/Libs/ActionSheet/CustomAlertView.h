//
//  CustomAlertView.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/11/1.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomAlertView : UIView

- (instancetype)initWithTitle:(NSString *)text ConfirmBlock:(void(^)())confirmBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
