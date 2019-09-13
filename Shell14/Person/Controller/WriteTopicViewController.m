//
//  WriteTopicViewController.m
//
//
//  Created by Qingyang Xu on 2018/10/24.
//

#import "WriteTopicViewController.h"
#import "CustomActionSheet.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WriteTopicViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIImageView *placeIma;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, copy)   NSString    *imageFile;
@property (nonatomic, strong) NSString    *imageStr;
@property (nonatomic, strong) NSData      *imageData;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UITextView *botTextView;
@property (nonatomic, retain) UILabel *botPlaceHolderLabel;
@property (nonatomic,strong)  NSMutableArray *array;

@end

@implementation WriteTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"写食话";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:0 target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColorWhite;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:0 target:self action:@selector(publishClick)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColorWhite;
    [self creatUI];
}

- (void)creatUI{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, AutoHeight(110))];
    _topView.backgroundColor = UIColorWhite;
    [self.view addSubview:_topView];
    
    _textView = [[UITextView alloc]init];
    _textView.delegate = self;
    _textView.backgroundColor = UIColorWhite;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.textColor = UIColorBlack;
    
    [self.topView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).with.offset(15);
        make.right.equalTo(self.topView).with.offset(-15);
        make.top.equalTo(self.topView).with.offset(AutoHeight(20));
        make.bottom.equalTo(self.topView);
    }];
    
    _placeHolderLabel = [[UILabel alloc] init];
    _placeHolderLabel.font = [UIFont systemFontOfSize:16];
    _placeHolderLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    _placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _placeHolderLabel.text = @"想说点什么";
    _placeHolderLabel.numberOfLines = 0;
    [self.textView addSubview:self.placeHolderLabel];
    
    [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.mas_equalTo(@0);
    }];
    
    _placeIma = [[UIImageView alloc]init];
    _placeIma.image = [UIImage imageNamed:@"upload"];
    _placeIma.userInteractionEnabled = YES;
    UITapGestureRecognizer *uploadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImage)];
    [_placeIma addGestureRecognizer:uploadTap];
    
    [self.view addSubview:_placeIma];
    [_placeIma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView);
        make.top.equalTo(self.textView.mas_bottom);
        make.width.height.mas_equalTo(64);
    }];
    
    _deleteBtn = [[UIButton alloc]init];
    [_deleteBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(uploadImage) forControlEvents:UIControlEventTouchUpInside];
    if (kStringIsEmpty(self.imageStr)) {
        _deleteBtn.hidden = YES;
        _deleteBtn.userInteractionEnabled = NO;
    }else{
        _deleteBtn.hidden = NO;
        _deleteBtn.userInteractionEnabled = YES;
    }
    
    [self.placeIma addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.placeIma);
        make.width.height.mas_equalTo(10);
    }];
    
    _botView = [[UIView alloc]init];
    _botView.backgroundColor = UIColorWhite;
    [self.view addSubview:_botView];
    [_botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.placeIma.mas_bottom).with.offset(AutoHeight(15));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(AutoHeight(50));
    }];
   
    _botTextView = [[UITextView alloc]init];
    _botTextView.delegate = self;
    _botTextView.backgroundColor = UIColorWhite;
    _botTextView.font = [UIFont systemFontOfSize:15];
    _botTextView.textColor = UIColorBlack;
    _botTextView.returnKeyType = UIReturnKeyDone;
    
    [self.botView addSubview:_botTextView];
    [_botTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView).with.offset(15);
        make.right.equalTo(self.botView).with.offset(-15);
        make.top.bottom.equalTo(self.botView);
    }];
    
    _botPlaceHolderLabel = [[UILabel alloc] init];
    _botPlaceHolderLabel.font = [UIFont systemFontOfSize:16];
    _botPlaceHolderLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    _botPlaceHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _botPlaceHolderLabel.text = @"# 添加标签(选填)";
    _botPlaceHolderLabel.numberOfLines = 0;
    [_botTextView addSubview:self.botPlaceHolderLabel];
    
    [_botPlaceHolderLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.mas_equalTo(@0);
    }];
}

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}
- (void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)publishClick{
    if (kStringIsEmpty(self.textView.text)) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return;
    }if (kStringIsEmpty(self.imageStr)) {
        [SVProgressHUD showInfoWithStatus:@"请上传图片"];
        return;
    }else{
        [_textView resignFirstResponder];
        [_botTextView resignFirstResponder];
        [TopicDataBaseManager openDB];
        UserInfoModel *info = [Utils GetUserInfo];
        [TopicDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"topic%@",info.phone]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        MyTopicModel *model = [[MyTopicModel alloc]init];
        model.content = self.textView.text;
        model.tagName = self.botTextView.text;
        model.time = [formatter stringFromDate:[NSDate date]];
        model.imageData = self.imageData;
        [TopicDataBaseManager insertDataWithTableName:[NSString stringWithFormat:@"topic%@",info.phone] model:model];
        
        [SVProgressHUD showInfoWithStatus:@"发布成功"];
        [self performBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } afterDelay:2.0];
    }
}
- (NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray array]init];
        [_array addObject:@"拍摄"];
        [_array addObject:@"从手机相册选择"];
    }
    return _array;
}
- (void)uploadImage{
    __weak typeof(self) weakSelf = self;
    CustomActionSheet *optionsView = [[CustomActionSheet alloc]initWithTitleView:nil optionsArr:self.array cancelTitle:@"取消" selectedBlock:^(NSInteger index) {
        NSString *optionsStr = weakSelf.array[index];
        if ([optionsStr isEqualToString:@"拍摄"]) {
            [weakSelf showCamera];
        }else if ([optionsStr isEqualToString:@"从手机相册选择"]) {
            [weakSelf showPhoto];
        }
    } cancelBlock:^{
        
    }];
    [self.view addSubview:optionsView];
}

#pragma mark 相机
- (void)showCamera{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
                imageVC.allowsEditing = NO;
                imageVC.delegate = self;
                imageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imageVC animated:YES completion:nil];
            }
        }];
    }else{
        UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
        imageVC.allowsEditing = NO;
        imageVC.delegate = self;
        imageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imageVC animated:YES completion:nil];
    }
}
#pragma mark 相册
-(void)showPhoto{
    UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: //已获取权限
                    imageVC.allowsEditing = NO;
                    imageVC.delegate = self;
                    imageVC.navigationBar.tintColor = [UIColor whiteColor];
                    imageVC.navigationBar.barTintColor = [UIColor colorWithHexString:@"#FA8C16"];
                    imageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:imageVC animated:YES completion:nil];
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
#pragma mark camare
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    __weak typeof(self) weakSelf = self;
    [weakSelf dismissViewControllerAnimated:YES completion:^{
        UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
        weakSelf.imageData = UIImageJPEGRepresentation(image,7.0);
        weakSelf.imageStr = [weakSelf.imageData base64EncodedStringWithOptions:0];
        weakSelf.imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/imageFile1.png"];
        [weakSelf.imageData writeToFile:weakSelf.imageFile atomically:NO];
        weakSelf.placeIma.image = image;
        weakSelf.deleteBtn.hidden = NO;
        weakSelf.deleteBtn.userInteractionEnabled = YES;
    }];
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == _textView) {
        _placeHolderLabel.hidden = YES;
    }if (textView == _botTextView) {
        _botPlaceHolderLabel.hidden = YES;
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView == _textView) {
        if ([textView.text isEqualToString:@""]) {
            _placeHolderLabel.hidden = NO;
        }
    }if (textView == _botTextView) {
        if ([textView.text isEqualToString:@""]) {
            _botPlaceHolderLabel.hidden = NO;
        }
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
