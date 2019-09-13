//
//  OpenAlbumTool.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/30.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenAlbumTool : NSObject

- (void)openAlbumWithVC:(UIViewController *)vc completion:(void (^)(UIImage *))completion;
- (void)openCameraWithVC:(UIViewController *)vc completion:(void (^)(UIImage *))completion;

@end

NS_ASSUME_NONNULL_END
