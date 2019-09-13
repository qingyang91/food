//
//  IngredientsTableViewCell.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/23.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "IngredientsTableViewCell.h"

@implementation IngredientsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lineIma.image = [self drawLineByImageView:self.lineIma];
}

- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {3,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithHexString:@"#D9D9D9"].CGColor);
    CGContextSetLineDash(line, 0,lengths, 1); //画虚线
    CGContextMoveToPoint(line, 0.0, 1.0); //开始画线
    CGContextAddLineToPoint(line, kScreenWidth, 1.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
