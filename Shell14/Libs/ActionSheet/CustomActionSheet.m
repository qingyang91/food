//
//  CustomActionSheet.m
//  APPiOS
//
//  Created by 清阳 on 2018/5/8.
//  Copyright © 2018年 shengxi. All rights reserved.
//

#import "CustomActionSheet.h"

@interface CustomActionSheet ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *optionsArr;
@property (nonatomic,   copy) NSString *cancelTitle;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic,   copy) void(^selectedBlock)(NSInteger);
@property (nonatomic,   copy) void(^cancelBlock)();
@end

@implementation CustomActionSheet

- (instancetype)initWithTitleView:(UIView *)titleView optionsArr:(NSArray *)optionsArr cancelTitle:(NSString *)cancelTitle selectedBlock:(void (^)(NSInteger))selectedBlock cancelBlock:(void (^)())cancelBlock{
    if (self = [super init]) {
        _headView = titleView;
        _optionsArr = optionsArr;
        _cancelTitle = cancelTitle;
        _cancelBlock = cancelBlock;
        _selectedBlock = selectedBlock;
        [self craetUI];
    }
    return self;
}
- (void)craetUI {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
}
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.clipsToBounds = YES;
        _tableView.rowHeight = 50.0;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = self.headView;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Navi_Cell"];
    }
    return _tableView;
}
#pragma mark TableViewDel
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0)?_optionsArr.count:1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Navi_Cell"];
    cell.backgroundColor = UIColorWhite;
    if (indexPath.section == 0) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenW, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        if (indexPath.row == 0) {
            cell.textLabel.text = _optionsArr[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.textLabel.textColor = UIColorBlack;
            [cell.contentView addSubview:line];
        }else{
            cell.textLabel.text = _optionsArr[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = UIColorBlack;
        }
    }else{
        cell.textLabel.text = _cancelTitle;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#919191"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.selectedBlock) {
            self.selectedBlock(indexPath.row);
        }
    } else {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else{
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    return footerView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}

- (void)show {
    _tableView.frame = CGRectMake(0, kScreenH, kScreenW, _tableView.rowHeight * (_optionsArr.count + 1) + _headView.bounds.size.height+10);
    __weak typeof(self) weakself=self;
   [UIView animateWithDuration:.3 animations:^{
        CGRect rect = weakself.tableView.frame;
        rect.origin.y -= weakself.tableView.bounds.size.height;
        weakself.tableView.frame = rect;
    }];
}

- (void)dismiss {
    __weak typeof(self) weakself=self;
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = weakself.tableView.frame;
        rect.origin.y += weakself.tableView.bounds.size.height;
        weakself.tableView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
