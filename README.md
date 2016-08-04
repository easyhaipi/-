# TouchIDAndGesture
手势和指纹解锁的demo综合，本demo做一个综合参考，留着之后的备用

具体细节：

1、手势解锁，直接使用现在成熟的三方手势（https://github.com/iosdeveloperpanc/PCGestureUnlock）

2、Touch ID指纹解锁
说明
Touch ID的调用接口是LocalAuthentication.framework，调用时需要导入头文件

 #import <LocalAuthentication/LocalAuthentication.h>
需要用的方法有两个


                - (BOOL)canEvaluatePolicy:(LAPolicy)policy 
                     error:(NSError * __autoreleasing *)error __attribute__((swift_error(none)));
用来验证设备支不支持Touch ID

 
     - (void)evaluatePolicy:(LAPolicy)policy
        localizedReason:(NSString *)localizedReason
                  reply:(void(^)(BOOL success, NSError * __nullable error))reply;
验证Touch ID（会有弹出框）

当输入错误的指纹时会弹出"再试一次"验证框

 //初始化
 LAContext *context = [LAContext new];
 context.localizedFallbackTitle = @"忘记密码";
回调方法
接口提供了Touch ID验证成功和失败的回调方法
       
       [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
       localizedReason:@"指纹验证"
                  reply:^(BOOL success, NSError * _Nullable error) {
                      if (success) {
                          //验证成功执行
                          NSLog(@"指纹识别成功");
                          //在主线程刷新view，不然会有卡顿
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [view removeFromSuperview];
                            
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
                             forKey:@"touchOn"];
                          });
                      }
                  }];

