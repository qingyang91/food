//
//  TopicDetailViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/25.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "LoginFourthViewController.h"
#import "MyLikeModel.h"
#import "LikeDataBase.h"

@interface TopicDetailViewController ()

@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"食话";
    if (self.model != nil) {
        self.headIma.image = [UIImage imageNamed:_model.name];
        self.nameLabel.text = _model.name;
        self.speciaLabel.text = _model.speciality;
        self.foodIma.image = [UIImage imageNamed:_model.imageName];
        self.contentLabel.text = _model.detailContent;
        self.tagLabel.text = _model.tagName;
        self.loveNumLabel.text = _model.likeNumber;
        self.attentionBtn.layer.cornerRadius = 10;
        self.attentionBtn.layer.masksToBounds = YES;
        if (_isAttention == 0) {
            self.attentionBtn.selected = YES;
            [self.attentionBtn setTitle:@"关注中" forState:UIControlStateNormal];
        }else{
            self.attentionBtn.selected = NO;
            [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }
        if (_isLike == 0) {
            self.likeBtn.selected = YES;
            [self.likeBtn setImage:[UIImage imageNamed:@"like 橙色"] forState:UIControlStateNormal];
        }else{
            self.likeBtn.selected = NO;
            [self.likeBtn setImage:[UIImage imageNamed:@"like 灰"] forState:UIControlStateNormal];
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        self.timeLabel.text = [formatter stringFromDate:[NSDate date]];
        UserInfoModel *info = [Utils GetUserInfo];
        if ([self.nameLabel.text isEqualToString:info.phone]) {
            self.likeBtn.userInteractionEnabled = NO;
            self.attentionBtn.userInteractionEnabled = NO;
        }
        if (kStringIsEmpty(_model.likeNumber)) {
            self.likeBtn.selected = NO;
            [self.likeBtn setImage:[UIImage imageNamed:@"like 灰"] forState:UIControlStateNormal];
        }
    }else{
        UserInfoModel *info = [Utils GetUserInfo];
        self.nameLabel.text = info.phone;
        self.headIma.image = [UIImage imageNamed:@"head"];
        self.contentLabel.text = _topModel.content;
        self.tagLabel.text = [NSString stringWithFormat:@"#%@#",_topModel.tagName];
        self.timeLabel.text = _topModel.time;
        self.speciaLabel.text = @"";
        self.loveNumLabel.text = @"";
        self.foodIma.image = [UIImage imageWithData:_topModel.imageData];
        self.likeBtn.userInteractionEnabled = NO;
        [self.likeBtn setImage:[UIImage imageNamed:@"like 灰"] forState:UIControlStateNormal];
        self.attentionBtn.userInteractionEnabled = NO;
        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        self.attentionBtn.layer.cornerRadius = 10;
        self.attentionBtn.layer.masksToBounds = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)likeClick:(id)sender {
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        self.likeBtn.selected = !self.likeBtn.selected;
        if (self.likeBtn.selected == YES) {
            
            UserInfoModel *info = [Utils GetUserInfo];
            [LikeDataBaseManager openDB];
            [LikeDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"like%@",info.phone]];
            MyLikeModel *likeModel = [[MyLikeModel alloc]init];
            likeModel.content = _model.tagName;
            [LikeDataBaseManager insertDataWithTableName:[NSString stringWithFormat:@"like%@",info.phone] model:likeModel];
            [self.likeBtn setImage:[UIImage imageNamed:@"like 橙色"] forState:UIControlStateNormal];
        }else{
            
            UserInfoModel *info = [Utils GetUserInfo];
            [LikeDataBaseManager openDB];
            NSMutableArray *saveArray = [LikeDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"like%@",info.phone]];
            NSMutableArray *deleteArray = [NSMutableArray new];
            for (MyLikeModel *model in saveArray) {
                if ([model.content isEqualToString:self.tagLabel.text]) {
                    [deleteArray addObject:model];
                }
            }
            MyLikeModel *model = deleteArray[0];
            [LikeDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"like%@",info.phone] ID:model.ID];
            [self.likeBtn setImage:[UIImage imageNamed:@"like 灰"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)attentionClick:(id)sender {
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        self.attentionBtn.selected = !self.attentionBtn.selected;
        if (self.attentionBtn.selected == YES) {
            
            UserInfoModel *info = [Utils GetUserInfo];
            [AttentionDataBaseManager openDB];
            [AttentionDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"attention%@",info.phone]];
            MyAttentionModel *attentionModel = [[MyAttentionModel alloc]init];
            attentionModel.name = _model.name;
            attentionModel.content = _model.speciality;
            [AttentionDataBaseManager insertDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone] model:attentionModel];
            [self.attentionBtn setTitle:@"关注中" forState:UIControlStateNormal];
            
        }else{
            
            UserInfoModel *info = [Utils GetUserInfo];
            [AttentionDataBaseManager openDB];
            NSMutableArray *saveArray = [AttentionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone]];
            NSMutableArray *deleteArray = [NSMutableArray new];
            for (MyAttentionModel *model in saveArray) {
                if ([model.name isEqualToString:self.nameLabel.text]) {
                    [deleteArray addObject:model];
                }
            }
            MyAttentionModel *model = deleteArray[0];
            [AttentionDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone] ID:model.ID];
            [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
            
        }
    }
}
@end
