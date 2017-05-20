//
//  XAPIManager.h
//  XGitHubDemo
//
//  Created by LiX i n long on 2017/5/20.
//  Copyright © 2017年 LiX i n long. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CALLBACK)(id obj);

@interface XAPIManager : NSObject

/**
 init

 @return self
 */
+ (instancetype)shardInstance;
/**
 get userinfo

 @param key serach key
 @param callback CALLBACK
 */
- (void)searchUserinfoWithKey:(NSString *)key callback:(CALLBACK)callback;

/**
 get user repos

 @param UserName username
 @param callback CALLBACK
 */
- (void)searchUserReposWithUserName:(NSString *)UserName callback:(CALLBACK)callback;

@end
