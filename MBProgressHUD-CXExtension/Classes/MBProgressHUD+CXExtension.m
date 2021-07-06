//
//  MBProgressHUD+CXExtension.m
//  MBProgressHUD-CXExtension
//
//  Created by CXTretar on 2021/7/4.
//

#import "MBProgressHUD+CXExtension.h"
#import "CXHUDCustomView.h"

@implementation MBProgressHUD (CXExtension)

#pragma mark - 🚌 Public

+ (void)cx_showLoadingInView:(UIView *)view title:(NSString *)title mask:(BOOL)mask {
    if (!view) {
        return;
    }
    MBProgressHUD *hud = [self createCustomHUDWithView:view title:title mask:mask];
    CXHUDCustomView *customView = [[CXHUDCustomView alloc] initWithTitle:title icon:@"" image:nil isLoading:YES];
    hud.customView = customView;
}

+ (void)cx_showLoadingInWindowWithTitle:(NSString *)title mask:(BOOL)mask {
    [self showActivityTitle:title isWindow:YES mask:mask];
}

+ (void)cx_showLoadingInViewWithTitle:(NSString *)title mask:(BOOL)mask {
    [self showActivityTitle:title isWindow:NO mask:mask];
}

+ (void)cx_showToastInView:(UIView *)view
                      title:(NSString *)title
                       icon:(NSString *)icon
                      image:(NSString *)image
                   duration:(NSTimeInterval)duration
                       mask:(BOOL)mask {
    [self createToastHUDWithView:view title:title icon:icon image:image duration:duration mask:mask];
}

+ (void)cx_showToastInWindowWithTitle:(NSString *)title
                                  icon:(NSString *)icon
                                 image:(NSString *)image
                              duration:(NSTimeInterval)duration
                                  mask:(BOOL)mask {
    [self showToastTitle:title icon:icon image:image duration:duration isWindow:YES mask:mask];
}

+ (void)cx_showToastInViewWithTitle:(NSString *)title
                                icon:(NSString *)icon
                               image:(NSString *)image
                            duration:(NSTimeInterval)duration
                                mask:(BOOL)mask {
    [self showToastTitle:title icon:icon image:image duration:duration isWindow:NO mask:mask];
}

+ (void)cx_hideHUD {
    UIView *widowView = (UIView*)[self getCurrentWindow];
    [self hideAllHUDsForView:widowView animated:YES];
    [self hideAllHUDsForView:[self getCurrentVC].view animated:YES];
}

#pragma mark - 🛩 ClassMethods
#pragma mark - ActivityHUD

+ (MBProgressHUD *)createCustomHUDWithView:(UIView *)view title:(NSString *)title mask:(BOOL)mask {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    if (!mask) {
        hud.userInteractionEnabled = NO;
    }
    return hud;
}

+ (void)showActivityTitle:(NSString *)title isWindow:(BOOL)isWindow mask:(BOOL)mask {
    if (![self getCurrentWindow]) {
        return;
    }
    UIView *view = isWindow ? (UIView *)[self getCurrentWindow] : [self getCurrentVC].view;
    MBProgressHUD *hud = [self createCustomHUDWithView:view title:title mask:mask];
    CXHUDCustomView *customView = [[CXHUDCustomView alloc] initWithTitle:title icon:@"" image:nil isLoading:YES];
    hud.customView = customView;
}

#pragma mark - ToastHUD

+ (MBProgressHUD *)createToastHUDWithView:(UIView *)view
                                    title:(NSString *)title
                                     icon:(NSString *)icon
                                    image:(NSString *)image
                                 duration:(NSTimeInterval)duration
                                     mask:(BOOL)mask {
    MBProgressHUD *hud = [self createCustomHUDWithView:view title:title mask:mask];
    
    CXHUDCustomView *customView = [[CXHUDCustomView alloc] initWithTitle:title icon:icon image:image isLoading:NO];
    hud.customView = customView;
    [hud hideAnimated:YES afterDelay:duration];
    return hud;
}

+ (void)showToastTitle:(NSString *)title
                  icon:(NSString *)icon
                 image:(NSString *)image
              duration:(NSTimeInterval)duration
              isWindow:(BOOL)isWindow
                  mask:(BOOL)mask {
    if (![self getCurrentWindow]) {
        return;
    }
    UIView *view = isWindow ? (UIView *)[self getCurrentWindow] : [self getCurrentVC].view;
    [self createToastHUDWithView:view title:title icon:icon image:image duration:duration mask:mask];
}

#pragma mark - HideHUD

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
    NSArray *huds = [MBProgressHUD allHUDsForView:view];
    for (MBProgressHUD *hud in huds) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:animated];
    }
    return [huds count];
}

+ (NSArray *)allHUDsForView:(UIView *)view {
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [huds addObject:aView];
        }
    }
    return [NSArray arrayWithArray:huds];
}

#pragma mark - CurrentVC

+ (UIWindow *)getCurrentWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }else {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

+ (UIViewController *)getCurrentVC {
    //当前windows的根控制器
    UIViewController *controller = [self getCurrentWindow].rootViewController;
    
    //通过循环一层一层往下查找
    while (YES) {
        //先判断是否有present的控制器
        if (controller.presentedViewController) {
            //有的话直接拿到弹出控制器，省去多余的判断
            controller = controller.presentedViewController;
        } else {
            if ([controller isKindOfClass:[UINavigationController class]]) {
                //如果是NavigationController，取最后一个控制器（当前）
                controller = [controller.childViewControllers lastObject];
            } else if ([controller isKindOfClass:[UITabBarController class]]) {
                //如果TabBarController，取当前控制器
                UITabBarController *tabBarController = (UITabBarController *)controller;
                controller = tabBarController.selectedViewController;
            } else {
                if (controller.childViewControllers.count > 0) {
                    //如果是普通控制器，找childViewControllers最后一个
                    controller = [controller.childViewControllers lastObject];
                } else {
                    //没有present，没有childViewController，则表示当前控制器
                    return controller;
                }
            }
        }
    }
}

@end
