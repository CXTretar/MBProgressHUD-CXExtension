//
//  CXHUDCustomView.h
//  MBProgressHUD-CXExtension
//
//  Created by CXTretar on 2021/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXHUDCustomView : UIView

- (instancetype)initWithTitle:(NSString *)title
                         icon:(NSString *)icon
                        image:(UIImage * _Nullable)image
                    isLoading:(BOOL)isLoading;

@end

NS_ASSUME_NONNULL_END
