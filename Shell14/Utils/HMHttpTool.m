//
//  HMHttpTool.m
//  HaiMao
//
//  Created by liaoguangcheng on 16/10/15.
//  Copyright © 2016年 liaoguangcheng. All rights reserved.
//

#import "HMHttpTool.h"
#import "AFNetworking.h"
#import kImportQMUI

static NSString *const kBaseURLString = Base_URL;

@interface AFHttpClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
@implementation AFHttpClient
+ (instancetype)sharedClient
{
    static AFHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10.0f;
        _sharedClient = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString] sessionConfiguration:configuration];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}
@end

@implementation HMHttpTool

+(void)GET:(NSString *)url params:(NSDictionary *)params
   success:(responseSuccess)success fail:(responseFail)fail{
    
    AFHTTPSessionManager *manager = [HMHttpTool managerWithBaseURL:nil sessionConfiguration:NO];
    [SVProgressHUD show];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        id dic = [HMHttpTool responseConfiguration:responseObject];
        
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

/** get请求***/
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    [[AFNetworkReachabilityManager manager]startMonitoring];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",@"text/plain", nil];
   
        [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {


        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            if (success) {
                 success(responseObject);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            if (failure) {
               // NSLog(@"%@", manager.requestSerializer.HTTPRequestHeaders);
                failure(error);
            }
        }];
    
}

/** post请求***/
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{

    NSString *urlString;
    if ([url containsString:@"http"]) {
        urlString = url;
    }else {
        urlString = [kBaseURLString stringByAppendingPathComponent:url];
    }
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    if (error) failure(error);
    
    [[[AFHttpClient sharedClient] dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD show];
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        //可获取下载进度
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [SVProgressHUD dismiss];
        
        if (error) {
            failure(error);
        }
        else {
            success(responseObject);
        }
    }] resume];
}

+(AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL  sessionConfiguration:(BOOL)isconfiguration{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =nil;
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    if (isconfiguration) {
        
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    }else{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return manager;
}

+(id)responseConfiguration:(id)responseObject{
    
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

@end
