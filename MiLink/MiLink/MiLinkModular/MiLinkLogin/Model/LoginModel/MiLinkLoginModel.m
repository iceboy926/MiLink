//
//  MiLinkLoginModel.m
//  MiLink
//
//  Created by Cain on 25/7/16.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "MiLinkLoginModel.h"
#import "MiLinkLoginController.h"
#import "MiLinkUserInfoModel.h"

@interface MiLinkLoginModel()

@property (nonatomic, strong) MiLinkLoginController *loginController;

@end

@implementation MiLinkLoginModel

- (instancetype)initLoginModelWithController:(UIViewController *)controller {
    
    if (self = [super init]) {
        self.loginController = (MiLinkLoginController *)controller;
    }
    
    return self;
}

- (void)loginMiLinkWithUserInfo:(NSDictionary *)userInfo {

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [sessionManager GET:LOGIN_ADDRESS
             parameters:userInfo
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    MiLinkUserInfoModel *userInfoModel = [MiLinkUserInfoModel yy_modelWithJSON:responseObject];
                    
                    [AppDelegate userInfoAppDelegate].pushURL = userInfoModel.data.pushUrl;
                    
                    if (userInfoModel.code == 120) {
                        
                        UIAlertView *loginFailedAlertView = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                                                       message:@"用户名或密码不正确"
                                                                                      delegate:self
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles: nil];
                        
                        [loginFailedAlertView show];
                        
                        return;
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"username"]
                                                              forKey:@"userName"];
                    
                    [self.loginController.loginViewManager reloadLoginView:YES];
        
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                    UIAlertView *loginFailedAlertView = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                                                   message:@"网络请求失败, 请稍后再试"
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles: nil];
                    
                    [loginFailedAlertView show];
                }];
}

@end
