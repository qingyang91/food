//
//  UploadMenuViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/24.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "UploadMenuViewController.h"
#import "HomeFourthTableViewCell.h"
#import "MaterialTableViewCell.h"
#import "AddStepTableViewCell.h"
#import "OpenAlbumTool.h"
#import "CustomActionSheet.h"
#import "CustomAlertView.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UploadMenuViewController ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MaterialTableViewCellDelegate,AddStepTableViewCellDelegate,UIImagePickerControllerDelegate>

{
    UIButton *selectedBtn;
}
@property (nonatomic, copy)   NSString *typeString;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) MaterialTableViewCell *cell;
@property (nonatomic, strong) AddStepTableViewCell *stepCell;
@property (nonatomic, strong) UIView   *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topImaView;
@property (nonatomic, strong) UILabel     *tipLabel;
@property (nonatomic, strong) UITextView  *menuTextView;
@property (nonatomic, strong) UILabel     *menuPlaceHolderLabel;
@property (nonatomic, strong) UITextView  *storyTextView;
@property (nonatomic, strong) UILabel     *storyPlaceHolderLabel;
@property (nonatomic, strong) UITextView  *skillTextView;
@property (nonatomic, strong) UILabel     *skillPlaceHolderLabel;
@property (nonatomic, strong) NSMutableArray *stepArray;
@property (nonatomic, strong) NSMutableArray *stuffArray;
@property (nonatomic, strong) NSMutableArray *dosageArray;
@property (nonatomic, copy)   NSString    *imageFile;
@property (nonatomic, strong) NSString    *imageStr;
@property (nonatomic, strong) NSData      *imageData;
@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic,strong)  NSMutableArray *array;
@property(nonatomic, strong)  OpenAlbumTool *tool;


@end

@implementation UploadMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self creatTableView];
    [self creatUI];
    [self creatSkillTextView];
    [self initData];
}

- (void)creatUI{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, AutoHeight(200)+145)];
    [_headView addSubview:self.topImaView];
    [_topImaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.headView);
        make.height.mas_equalTo(165);
    }];
    
    UIImageView *photoIma = [[UIImageView alloc]init];
    photoIma.image = [UIImage imageNamed:@"传照片"];
    
    [_topImaView addSubview:photoIma];
    [photoIma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topImaView.mas_centerX);
        make.top.equalTo(self.topImaView).with.offset(60);
        make.height.width.mas_equalTo(22);
    }];
    
    [_topImaView addSubview:self.tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topImaView.mas_centerX);
        make.top.equalTo(photoIma.mas_bottom).with.offset(5);
        make.width.mas_equalTo(60);
    }];
    
    [_headView addSubview:self.menuTextView];
    [_menuTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headView);
        make.top.equalTo(self.topImaView.mas_bottom).with.offset(AutoHeight(25));
        make.height.mas_equalTo(AutoHeight(25));
    }];
    
    [_menuTextView addSubview:self.menuPlaceHolderLabel];
    [_menuPlaceHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.menuTextView.mas_centerX);
        make.top.equalTo(self.menuTextView).with.offset(AutoHeight(6));
    }];
    
    [_headView addSubview:self.storyTextView];
    [_storyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headView);
        make.top.equalTo(self.menuTextView.mas_bottom).with.offset(AutoHeight(25));
        make.height.mas_equalTo(AutoHeight(25));
    }];
    
    [_storyTextView addSubview:self.storyPlaceHolderLabel];
    [_storyPlaceHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.storyTextView.mas_centerX);
        make.top.equalTo(self.storyTextView).with.offset(AutoHeight(6));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"类别";
    label.textColor = [UIColor colorWithHexString:@"#585858"];
    label.font = [UIFont boldSystemFontOfSize:16];
    
    [_headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView.mas_centerX);
        make.top.equalTo(self.storyTextView.mas_bottom).with.offset(AutoHeight(25));
    }];
    
    UIView *menuView = [[UIView alloc]init];
    
    [self.headView addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headView);
        make.top.equalTo(label.mas_bottom).with.offset(AutoHeight(15));
        make.height.mas_equalTo(15);
    }];
    
    NSArray *title = @[@"家常菜谱",@"一日三餐",@"烘培甜品",@"热门推荐"];
    UIButton *button=nil;
    for (int i=0;i<title.count;i++){
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 0, kScreenW/title.count, AutoHeight(15))];
        [btn setTitle:title[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        button = btn;
        button.tag = 300+i;
        if (btn.tag == 300) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#FA8C16"] forState:UIControlStateNormal];
            selectedBtn = btn;
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn];
    }
    self.tableView.tableHeaderView = self.headView;
    
    [self.view addSubview:self.publishBtn];
}
- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, kScreenH-kNavBarHAbove7-((kIs_iPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs_Max) ? 64 : 44)) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"AddStepTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddStepTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HomeFourthTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeFourthTableViewCell"];
    [self.view addSubview:_tableView];
}
- (void)creatSkillTextView{
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 145)];
    footView.backgroundColor = UIColorWhite;
    
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = 500;
    [btn setTitle:@"+再增加一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FA8C16"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView);
        make.centerX.mas_equalTo(footView.mas_centerX);
    }];

    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"烹饪技巧";
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor colorWithHexString:@"#585858"];
    
    [footView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(footView.mas_centerX);
    }];
    
    _skillTextView = [[UITextView alloc]init];
    _skillTextView.delegate = self;
    _skillTextView.backgroundColor = UIColorWhite;
    _skillTextView.font = [UIFont systemFontOfSize:12];
    _skillTextView.textAlignment = NSTextAlignmentLeft;
    _skillTextView.textColor = UIColorBlack;
    _skillTextView.returnKeyType = UIReturnKeyDone;
    if ([self.title isEqualToString:@"修改菜谱"]) {
        _skillTextView.text = self.model.skill;
    }
    
    [footView addSubview:self.skillTextView];
    [_skillTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).with.offset(15);
        make.right.equalTo(footView).with.offset(-15);
        make.top.equalTo(label.mas_bottom).with.offset(10);
        make.height.mas_equalTo(100);
    }];
    
    
    [_skillTextView addSubview:self.skillPlaceHolderLabel];
    [_skillPlaceHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.skillTextView.mas_centerX);
        make.top.equalTo(self.skillTextView).with.offset(AutoHeight(6));
    }];
    self.tableView.tableFooterView = footView;
}

#pragma mark 修改上传菜谱

- (void)publishClick{
    
    NSLog(@"%@%@%@",self.stepArray,self.dosageArray,self.stuffArray);
    if (self.topImaView.image == nil) {
        [SVProgressHUD showInfoWithStatus:@"上传封面照片"];
        return;
    }if (kStringIsEmpty(self.menuTextView.text)) {
        [SVProgressHUD showInfoWithStatus:@"填写菜谱名称"];
        return;
    }if (kStringIsEmpty(self.storyTextView.text)) {
        [SVProgressHUD showInfoWithStatus:@"填写菜的背后故事"];
        return;
    }if ([self.stuffArray containsObject:@""] || [self.dosageArray containsObject:@""]) {
        [SVProgressHUD showInfoWithStatus:@"填写用料"];
        return;
    }if ([self.stepArray containsObject:@""]) {
        [SVProgressHUD showInfoWithStatus:@"填写步骤"];
        return;
    }if ([self.imageNameArray containsObject:@""]) {
        [SVProgressHUD showInfoWithStatus:@"上传步骤图片"];
        return;
    }if (kStringIsEmpty(self.skillTextView.text)) {
        [SVProgressHUD showInfoWithStatus:@"填写烹饪技巧"];
        return;
    }else{
        if ([self.title isEqualToString:@"修改菜谱"]) {
            [self creditMenu];
        }else{
            [self uploadMenu];
        }
    }
}
- (void)creditMenu{
    NSMutableArray *dataArray = [NSMutableArray new];
    for (NSInteger i = 0; i<self.stuffArray.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@-%@",self.stuffArray[i],self.dosageArray[i]];
        [dataArray addObject:string];
    }
    NSLog(@"%@",dataArray);
    UserInfoModel *info = [Utils GetUserInfo];
    [CreationDataBaseManager openDB];
    MyCreationModel *model = [[MyCreationModel alloc]init];
    if (self.imageData) {
        model.imageData = self.imageData;
    }else{
        model.imageData = self.model.imageData;
    }
    model.name = self.menuTextView.text;
    model.content = self.storyTextView.text;
    model.material = [dataArray componentsJoinedByString:@";"];
    model.step = [self.stepArray componentsJoinedByString:@"；"];
    model.stepNumber = [NSString stringWithFormat:@"%ld",self.stepArray.count];
    model.skill = self.skillTextView.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    model.time = [formatter stringFromDate:[NSDate date]];
    [CreationDataBaseManager updataWithTableName:[NSString stringWithFormat:@"creation%@",info.phone] model:model forID:self.model.ID];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithTitle:@"修改已成功，请等待审核，您可以在 【我的-作品】中查看" ConfirmBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView show];
}
- (void)uploadMenu{
    NSMutableArray *dataArray = [NSMutableArray new];
    for (NSInteger i = 0; i<self.stuffArray.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@-%@",self.stuffArray[i],self.dosageArray[i]];
        [dataArray addObject:string];
    }
    NSLog(@"%@",dataArray);
    UserInfoModel *info = [Utils GetUserInfo];
    [CreationDataBaseManager openDB];
    [CreationDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"creation%@",info.phone]];
    
    MyCreationModel *model = [[MyCreationModel alloc]init];
    model.imageData = self.imageData;
    model.name = self.menuTextView.text;
    model.content = self.storyTextView.text;
    model.material = [dataArray componentsJoinedByString:@";"];
    model.step = [self.stepArray componentsJoinedByString:@"；"];
    model.stepNumber = [NSString stringWithFormat:@"%ld",self.stepArray.count];
    model.skill = self.skillTextView.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    model.time = [formatter stringFromDate:[NSDate date]];
    [CreationDataBaseManager insertDataWithTableName:[NSString stringWithFormat:@"creation%@",info.phone] model:model];
    
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithTitle:@"发布已成功，请等待审核，您可以在 【我的-作品】中查看" ConfirmBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView show];
}
#pragma mark 上传照片
- (void)uploadPhoto{
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    __weak typeof(self) weakSelf = self;
    [weakSelf dismissViewControllerAnimated:YES completion:^{
        UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
        weakSelf.imageData = UIImageJPEGRepresentation(image,7.0);
        weakSelf.imageStr = [weakSelf.imageData base64EncodedStringWithOptions:0];
        weakSelf.imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/imageFile.png"];
        [weakSelf.imageData writeToFile:weakSelf.imageFile atomically:NO];
        weakSelf.topImaView.image = image;
    }];
}
#pragma mark 增加cell
- (void)addCell:(UIButton *)btn{
    if (btn.tag == 400) {
        [_stuffArray addObject:@""];
        [_dosageArray addObject:@""];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_stuffArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        
    }else{
        [_stepArray addObject:@""];
        [_imageNameArray addObject:@""];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_stepArray.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}
- (void)btnClick:(UIButton *)btn{
    if (selectedBtn) {
        [selectedBtn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    }
    selectedBtn = btn;
    _typeString = btn.titleLabel.text;
    [selectedBtn setTitleColor:[UIColor colorWithHexString:@"#FA8C16"] forState:UIControlStateNormal];
    
}

- (instancetype)init{
    if (self) {
        self = [super init];
        _stepArray = [NSMutableArray new];
        _stuffArray = [NSMutableArray new];
        _dosageArray = [NSMutableArray new];
        _imageNameArray = [NSMutableArray new];
    }
    return self;
}
- (NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray array]init];
        [_array addObject:@"拍摄"];
        [_array addObject:@"从手机相册选择"];
    }
    return _array;
}
- (void)initData{
    _stuffArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    _dosageArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    _stepArray = [NSMutableArray arrayWithObjects:@"",@"", nil];
    _imageNameArray = [NSMutableArray arrayWithObjects:@"",@"", nil];
}
#pragma mark MaterialTableViewCell代理
- (void)contentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath {
    [self.stuffArray replaceObjectAtIndex:indexPath.row withObject:text];
    MaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.nameField becomeFirstResponder];
}
- (void)dosageFieldContentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath{
    [self.dosageArray replaceObjectAtIndex:indexPath.row withObject:text];
    MaterialTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.dosageField becomeFirstResponder];
}
#pragma mark AddStepTableViewCell代理
- (void)contentStepDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath{
    [self.stepArray replaceObjectAtIndex:indexPath.row withObject:text];
    AddStepTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.stepDetailField becomeFirstResponder];
}
- (void)contentStepImaDidChanged:(NSData *)data forIndexPath:(NSIndexPath *)indexPath{
    if (kStringIsEmpty(self.menuTextView.text)) {
        [SVProgressHUD showInfoWithStatus:@"先填写菜谱名称"];
        return;
    }else{
        AddStepTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        OpenAlbumTool *tool = [[OpenAlbumTool alloc]init];
        __weak typeof(self) weakSelf = self;
        CustomActionSheet *optionsView = [[CustomActionSheet alloc]initWithTitleView:nil optionsArr:self.array cancelTitle:@"取消" selectedBlock:^(NSInteger index) {
            NSString *optionsStr = weakSelf.array[index];
            if ([optionsStr isEqualToString:@"拍摄"]) {
                [tool openCameraWithVC:self completion:^(UIImage * _Nonnull image) {
                    NSData *data = UIImageJPEGRepresentation(image,5.0);
                    [weakSelf saveImage:data WithName:[NSString stringWithFormat:@"Documents%@%ld.png",self.menuTextView.text,indexPath.row]];
                    cell.imageName = [NSString stringWithFormat:@"Documents%@%ld.png",self.menuTextView.text,indexPath.row];
                    [weakSelf.imageNameArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"Documents%@%ld.png",self.menuTextView.text,indexPath.row]];
                    [self.tableView reloadData];
                }];
            }else if ([optionsStr isEqualToString:@"从手机相册选择"]) {
                [tool openAlbumWithVC:self completion:^(UIImage * _Nonnull image) {
                    NSData *data = UIImageJPEGRepresentation(image,5.0);
                    [weakSelf saveImage:data WithName:[NSString stringWithFormat:@"Documents%@%ld.png",self.menuTextView.text,indexPath.row]];
                    cell.imageName = [NSString stringWithFormat:@"Documents%@%ld.png",self.menuTextView.text,indexPath.row];
                    [weakSelf.imageNameArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"Documents%@%ld.png",self.menuTextView.text,indexPath.row]];
                    [self.tableView reloadData];
                }];
            }
        } cancelBlock:^{
            
        }];
        [self.view addSubview:optionsView];
        _tool = tool;
    }
}
- (void)saveImage:(NSData *)data WithName:(NSString *)imageName{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    
    NSString * fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [data writeToFile:fullPathToFile atomically:NO];
}
#pragma mark 删除cell
- (void)deleteCellClick:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [_stuffArray removeObjectAtIndex:indexPath.row];
    [_dosageArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

- (void)deleteStep:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [_stepArray removeObjectAtIndex:indexPath.row];
    [_imageNameArray removeObjectAtIndex:indexPath.row];
    AddStepTableViewCell *stepCell = [self.tableView cellForRowAtIndexPath:indexPath];
    stepCell.imageName = @"";
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents%@%ld.png",self.menuTextView.text,indexPath.row]];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}
#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 32)];
        view.backgroundColor = UIColorWhite;
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"用料";
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"#585858"];
        
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).with.offset(5);
            make.centerX.mas_equalTo(view.mas_centerX);
        }];
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 32)];
        view.backgroundColor = UIColorWhite;
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"步骤";
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"#585858"];
        
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).with.offset(5);
            make.centerX.mas_equalTo(view.mas_centerX);
        }];
        return view;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 25;
    }else{
        return 0.1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
        view.backgroundColor = UIColorWhite;
        
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = 400;
        [btn setTitle:@"+再增加一行" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FA8C16"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.centerX.mas_equalTo(view.mas_centerX);
        }];
        return view;
    }else{
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _stuffArray.count;
    }else{
        return _stepArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 35;
    }else{
        return 225;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"MaterialTableViewCell";
        _cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!_cell) {
            _cell = [[MaterialTableViewCell alloc]initWithStyle:0 reuseIdentifier:cellIdentifier];
        }
        _cell.nameField.delegate = self;
        _cell.dosageField.delegate = self;
        _cell.delegate = self;
        _cell.nameField.indexPath = indexPath;
        _cell.dosageField.indexPath = indexPath;
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _cell;
    }else{
        _stepCell = [tableView dequeueReusableCellWithIdentifier:@"AddStepTableViewCell" forIndexPath:indexPath];
        _stepCell.delegate = self;
        if (kStringIsEmpty(self.stepCell.imageName)) {
            _stepCell.stepIma.userInteractionEnabled = YES;
        }else{
            _stepCell.stepIma.userInteractionEnabled = NO;
        }
        _stepCell.stepDetailField.indexPath = indexPath;
        _stepCell.stepIma.indexPath = indexPath;
        _stepCell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        _stepCell.stepDetailField.delegate = self;
        _stepCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _stepCell;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        MaterialTableViewCell *customCell = (MaterialTableViewCell *)cell;
        customCell.nameField.text = self.stuffArray[indexPath.row];
        customCell.dosageField.text = self.dosageArray[indexPath.row];
    }if (indexPath.section == 1) {
        AddStepTableViewCell *stepCell = (AddStepTableViewCell *)cell;
        stepCell.stepDetailField.text = self.stepArray[indexPath.row];
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString * fullPathToFile = [documentsDirectory stringByAppendingPathComponent:self.imageNameArray[indexPath.row]];
        NSString * path = fullPathToFile;
        NSData * data = [NSData dataWithContentsOfFile:path];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            stepCell.stepIma.image = image;
        }else{
            stepCell.stepIma.image = nil;
        }
    }
}
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == _menuTextView) {
        _menuPlaceHolderLabel.hidden = YES;
    }if (textView == _storyTextView) {
        _storyPlaceHolderLabel.hidden = YES;
    }if (textView == _skillTextView) {
        _skillPlaceHolderLabel.hidden = YES;
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView == _menuTextView) {
        if ([textView.text isEqualToString:@""]) {
            _menuPlaceHolderLabel.hidden = NO;
        }
    }if (textView == _storyTextView) {
        if ([textView.text isEqualToString:@""]) {
            _storyPlaceHolderLabel.hidden = NO;
        }
    }if (textView == _skillTextView) {
        if ([textView.text isEqualToString:@""]) {
            _skillPlaceHolderLabel.hidden = NO;
        }
    }
    return YES;
}
#pragma mark 懒加载
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]init];
    }
    return _headView;
}
- (UIImageView *)topImaView{
    if (!_topImaView) {
        _topImaView = [[UIImageView alloc]init];
        _topImaView.userInteractionEnabled = YES;
        _topImaView.contentMode = UIViewContentModeScaleAspectFit;
        _topImaView.image = [UIImage imageWithData:self.model.imageData];
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadPhoto)];
        [_topImaView addGestureRecognizer:tap];
        _topImaView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
    return _topImaView;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"上传封面";
        _tipLabel.textColor = [UIColor colorWithHexString:@"#A5A5A5"];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
- (UITextView *)menuTextView{
    if (!_menuTextView) {
        _menuTextView = [[UITextView alloc]init];
        _menuTextView.delegate = self;
        if ([self.title isEqualToString:@"修改菜谱"]) {
            _menuTextView.text = self.model.name;
        }
        _menuTextView.backgroundColor = UIColorWhite;
        _menuTextView.font = [UIFont systemFontOfSize:18];
        _menuTextView.textAlignment = NSTextAlignmentCenter;
        _menuTextView.textColor = UIColorBlack;
        _menuTextView.returnKeyType = UIReturnKeyDone;
    }
    return _menuTextView;
}
- (UILabel *)menuPlaceHolderLabel{
    if (!_menuPlaceHolderLabel) {
        _menuPlaceHolderLabel = [[UILabel alloc] init];
        _menuPlaceHolderLabel.font = [UIFont systemFontOfSize:18];
        _menuPlaceHolderLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        _menuPlaceHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _menuPlaceHolderLabel.text = @"＋添加菜谱名称";
        if ([self.title isEqualToString:@"修改菜谱"]) {
            _menuPlaceHolderLabel.hidden = YES;
        }
        _menuPlaceHolderLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _menuPlaceHolderLabel;
}
- (UITextView *)storyTextView{
    if (!_storyTextView) {
        _storyTextView = [[UITextView alloc]init];
        _storyTextView.delegate = self;
        if ([self.title isEqualToString:@"修改菜谱"]) {
            _storyTextView.text = self.model.content;
        }
        _storyTextView.backgroundColor = UIColorWhite;
        _storyTextView.font = [UIFont systemFontOfSize:18];
        _storyTextView.textAlignment = NSTextAlignmentCenter;
        _storyTextView.textColor = UIColorBlack;
        _storyTextView.returnKeyType = UIReturnKeyDone;
    }
    return _storyTextView;
}
- (UILabel *)storyPlaceHolderLabel{
    if (!_storyPlaceHolderLabel) {
        _storyPlaceHolderLabel = [[UILabel alloc] init];
        _storyPlaceHolderLabel.font = [UIFont systemFontOfSize:18];
        _storyPlaceHolderLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        _storyPlaceHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _storyPlaceHolderLabel.text = @"＋说说这道菜背后的故事";
        if ([self.title isEqualToString:@"修改菜谱"]) {
            _storyPlaceHolderLabel.hidden = YES;
        }
        _storyPlaceHolderLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _storyPlaceHolderLabel;
}
- (UILabel *)skillPlaceHolderLabel{
    if (!_skillPlaceHolderLabel) {
        _skillPlaceHolderLabel = [[UILabel alloc] init];
        _skillPlaceHolderLabel.font = [UIFont systemFontOfSize:12];
        _skillPlaceHolderLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        _skillPlaceHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _skillPlaceHolderLabel.text = @"说说这道菜有哪些厨友可以参考到的小技巧呢？";
        if ([self.title isEqualToString:@"修改菜谱"]) {
            _skillPlaceHolderLabel.hidden = YES;
        }
        _skillPlaceHolderLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _skillPlaceHolderLabel;
}
- (UIButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH-((kIs_iPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs_Max) ? 64 : 44), kScreenW, (kIs_iPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs_Max) ? 64 : 44)];
        _publishBtn.backgroundColor = [UIColor colorWithHexString:@"#FA8C16"];
        _publishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_publishBtn setTitle:@"发布菜谱" forState:UIControlStateNormal];
        [_publishBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
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
