//
//  UserInfoModel.h
//  BeikoCube
//
//  Created by Qingyang Xu on 2018/8/14.
//  Copyright © 2018年 光磊信息. All rights reserved.
//

#import "JSONModel.h"

@interface UserInfoModel : JSONModel

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *token;

@end
