//
//  MBProgressHUD+CXExtension.h
//  MBProgressHUD-CXExtension
//
//  Created by CXTretar on 2021/7/4.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (CXExtension)

+ (void)cx_showLoadingInView:(UIView *)view title:(NSString *)title mask:(BOOL)mask;

+ (void)cx_showLoadingInWindowWithTitle:(NSString *)title mask:(BOOL)mask;

+ (void)cx_showLoadingInViewWithTitle:(NSString *)title mask:(BOOL)mask;

+ (void)cx_showToastInView:(UIView *)view
                      title:(NSString *)title
                       icon:(NSString *)icon
                      image:(NSString *)image
                   duration:(NSTimeInterval)duration
                       mask:(BOOL)mask;

+ (void)cx_showToastInWindowWithTitle:(NSString *)title
                                  icon:(NSString *)icon
                                 image:(NSString *)image
                              duration:(NSTimeInterval)duration
                                  mask:(BOOL)mask ;

+ (void)cx_showToastInViewWithTitle:(NSString *)title
                                icon:(NSString *)icon
                               image:(NSString *)image
                            duration:(NSTimeInterval)duration
                                mask:(BOOL)mask;
+ (void)cx_hideHUD;

@end

NS_ASSUME_NONNULL_END
