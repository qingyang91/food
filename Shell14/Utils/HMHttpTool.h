//
//  HMHttpTool.h
//  HaiMao
//
//  Created by liaoguangcheng on 16/10/15.
//  Copyright © 2016年 liaoguangcheng. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void (^HttpSuccessBlock) (NSDictionary * JSONDic);
typedef void (^HttpFailureBlock) (NSError *error);

/**
 *  宏定义请求成功的block
 *
 *  @param response 请求成功返回的数据
 */
typedef void (^responseSuccess)(NSURLSessionDataTask * task,id responseObject);

/**
 *  宏定义请求失败的block
 *
 *  @param error 报错信息
 */
typedef void (^responseFail)(NSURLSessionDataTask * task, NSError * error);


@interface HMHttpTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+(void)GET:(NSString *)url params:(NSDictionary *)params
   success:(responseSuccess)success fail:(responseFail)fail;

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */


+ (void)post:(NSString *)url params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;





@end
