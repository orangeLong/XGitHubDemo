//
//  XAPIManager.m
//  XGitHubDemo
//
//  Created by LiX i n long on 2017/5/20.
//  Copyright © 2017年 LiX i n long. All rights reserved.
//

#import "XAPIManager.h"

#define XAPI_HOST @"https://api.github.com"

@interface XAPIManager ()<NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSMutableArray <NSURLSessionTask *>*taskArray;

@end

@implementation XAPIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.taskArray = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)shardInstance
{
    static XAPIManager *apiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiManager = [[XAPIManager alloc] init];
    });
    return apiManager;
}

- (void)requestWithUrlString:(NSString *)urlString callback:(CALLBACK)callback
{
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //github权限问题 添加token之后搜索api的litmit从10增加到30 其他api从60增加到5000
    [request addValue:@"token e567558344f1fbbfe63a91ee33324b5471d7d89e" forHTTPHeaderField:@"Authorization"];
    NSURLSessionTask *sessionTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!error) {
                id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (callback) {
                    callback(obj);
                }
            }
        });
    }];
    [self.taskArray addObject:sessionTask];
    [sessionTask resume];
}

- (void)searchUserinfoWithKey:(NSString *)key callback:(CALLBACK)callback
{
    /**< search之前cancel掉之前的请求*/
    [self.taskArray enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [self.taskArray removeAllObjects];
    if (!key.length) {
        return;
    }
    NSString *apiPath = [NSString stringWithFormat:@"search/users?q=%@", key];
    NSString *urlString = [XAPI_HOST stringByAppendingPathComponent:apiPath];
    [self requestWithUrlString:urlString callback:callback];
}

- (void)searchUserReposWithUserName:(NSString *)UserName callback:(CALLBACK)callback
{
    NSString *apiPath = [NSString stringWithFormat:@"users/%@/repos", UserName];
    NSString *urlString = [XAPI_HOST stringByAppendingPathComponent:apiPath];
    [self requestWithUrlString:urlString callback:callback];
}

@end
