//
//  UserInfoModel.m
//  BeikoCube
//
//  Created by Qingyang Xu on 2018/8/14.
//  Copyright © 2018年 光磊信息. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

//将对象编码(即:序列化)
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_uid forKey:@"uid"];
    [aCoder encodeObject:_status forKey:@"status"];
    [aCoder encodeObject:_token forKey:@"token"];
}

//将对象解码(反序列化)
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.token = [aDecoder decodeObjectForKey:@"token"];

    }
    
    return (self);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
