//
//  XUserViewModel.m
//  XGitHubDemo
//
//  Created by LiX i n long on 2017/5/20.
//  Copyright © 2017年 LiX i n long. All rights reserved.
//

#import "XUserViewModel.h"

#import "XAPIManager.h"

@implementation XUserViewModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        id name = dic[@"login"];
        if (name && [name isKindOfClass:[NSString class]]) {
            self.userName = name;
        }
        id imagePath = dic[@"avatar_url"];
        if (imagePath && [imagePath isKindOfClass:[NSString class]]) {
            self.userImagePath = imagePath;
        }
    }
    return self;
}

- (NSString *)userlanguage
{
    if (!_userlanguage) {
        [self reposRequest];
    }
    return _userlanguage;
}


/**
 请求数据
 */
- (void)reposRequest
{
    [[XAPIManager shardInstance] searchUserReposWithUserName:self.userName callback:^(id obj) {
        NSDictionary *allLanguageDic = [self allLanguageDicWithObj:obj];
        [self preferenceWithLanguageDic:allLanguageDic];
    }];
}

/**
 从后台返回的数据中组装字典

 @param obj 后台数据
 @return 语言组成的字典
 */
- (NSDictionary *)allLanguageDicWithObj:(id)obj
{
    NSMutableDictionary *totalDic = [NSMutableDictionary dictionary];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in obj) {
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                id language = dic[@"language"];
                if (language && [language isKindOfClass:[NSString class]]) {
                    NSString *count = totalDic[language];
                    if (count) {
                        count = [NSString stringWithFormat:@"%d", [count integerValue] + 1];
                    } else {
                        count = @"1";
                    }
                    [totalDic setObject:count forKey:language];
                }
            }
        }
    }
    return totalDic;
}

/**
 对组装后的语言字典排序并找到所有并列第一的语言 组成string并赋给userlanguage

 @param totalDic 语言字典
 */
- (void)preferenceWithLanguageDic:(NSDictionary *)totalDic
{
    if (totalDic.count) {
        NSArray *sortArray = [[totalDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [totalDic[obj1] integerValue] < [totalDic[obj2] integerValue];
        }];
        NSString *firstLanguage = [sortArray firstObject];
        NSMutableString *lanStr = [NSMutableString stringWithString:firstLanguage];
        for (NSString *lan in sortArray) {
            if (![lan isEqualToString:firstLanguage]) {
                if ([totalDic[lan] isEqualToString:totalDic[firstLanguage]]) {
                    [lanStr appendFormat:@",%@", lan];
                }
            }
        }
        self.userlanguage = lanStr;
//        NSLog(@"%@---%@----%@----%@", _userName, totalDic, sortArray, _userlanguage);
    }
}

@end
