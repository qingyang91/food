//
//  CustomImageView.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/30.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomImageView : UIImageView

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSData *imageData;


@end

NS_ASSUME_NONNULL_END
