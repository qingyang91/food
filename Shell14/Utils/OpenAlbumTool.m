//
//  OpenAlbumTool.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/30.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "OpenAlbumTool.h"

@interface OpenAlbumTool()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void (^didPickImageBlock)(UIImage * );
@property (nonatomic, copy) void (^didOpenCameraBlock)(UIImage *);

@end

@implementation OpenAlbumTool


- (void)openAlbumWithVC:(UIViewController *)vc completion:(void (^)(UIImage *))completion {
    _didPickImageBlock = completion;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: //已获取权限
                    picker.allowsEditing = NO;
                    picker.delegate = self;
                    picker.navigationBar.tintColor = [UIColor whiteColor];
                    picker.navigationBar.barTintColor = [UIColor colorWithHexString:@"#FA8C16"];
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [vc presentViewController:picker animated:YES completion:nil];
                    break;
                    
                case PHAuthorizationStatusDenied:
                    break;
                    
                case PHAuthorizationStatusRestricted:
                    break;
                    
                default:
                    break;
            }
        });
    }];
}

- (void)openCameraWithVC:(UIViewController *)vc completion:(void (^)(UIImage * _Nonnull))completion{
    _didOpenCameraBlock = completion;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
                imageVC.allowsEditing = NO;
                imageVC.delegate = self;
                imageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [vc presentViewController:imageVC animated:YES completion:nil];
            }
        }];
    }else{
        UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
        imageVC.allowsEditing = NO;
        imageVC.delegate = self;
        imageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [vc presentViewController:imageVC animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (_didPickImageBlock) {
        _didPickImageBlock(image);
    }
    if (_didOpenCameraBlock) {
        _didOpenCameraBlock(image);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
