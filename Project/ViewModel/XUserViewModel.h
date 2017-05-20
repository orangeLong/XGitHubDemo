//
//  XUserViewModel.h
//  XGitHubDemo
//
//  Created by LiX i n long on 2017/5/20.
//  Copyright © 2017年 LiX i n long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XUserViewModel : NSObject


@property (nonatomic, copy) NSString *userName;         /**< 用户名*/
@property (nonatomic, copy) NSString *userImagePath;    /**< 头像地址*/
@property (nonatomic, copy) NSString *userlanguage;     /**< 用户偏好语言*/

/**
 init

 @param dic remote dic
 @return self
 */
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
