//
//  ViewController.m
//  指纹解锁
//
//  Created by taobaichi on 16/8/4.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

#import "ViewController.h"


#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手势指纹验证";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----指纹解锁
- (IBAction)touchiIDAction:(UIButton *)sender {
  
    
    
    
    LAContext *context = [[LAContext alloc] init];
    
    context.localizedFallbackTitle = @"忘记密码";
    NSError *error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"设置支持TouchID");
        
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:view];
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹验证" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                //验证成功执行
                NSLog(@"指纹识别成功");
                //在主线程刷新view，不然会有卡顿
                dispatch_async(dispatch_get_main_queue(), ^{
                    [view removeFromSuperview];
                
                    NSLog(@"在主线程刷新view");
                });
            } else {
                if (error.code == kLAErrorUserFallback) {
                    //Fallback按钮被点击执行
                    NSLog(@"Fallback按钮被点击");
                } else if (error.code == kLAErrorUserCancel) {
                    //取消按钮被点击执行
                    NSLog(@"取消按钮被点击");
                } else {
                    //指纹识别失败执行
                    NSLog(@"指纹识别失败");
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [view removeFromSuperview];
                   
                });
            }

        }];
        
        
        
    }else {
        NSLog(@"设备不支持Touch ID: %@", error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持Touch ID" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
          
        }];
        [alert addAction:action];
        
    }
    
  }

@end
