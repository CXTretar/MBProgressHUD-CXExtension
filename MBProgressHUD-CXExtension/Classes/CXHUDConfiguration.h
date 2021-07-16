//
//  CXHUDConfiguration.h
//  MBProgressHUD-CXExtension
//
//  Created by CXTretar on 2021/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat const kCXHUDToastTextMinWidth = 96; // 文字最小宽度
static CGFloat const kCXHUDToastTextMaxWidth = 192; // 文字最大宽度
static CGFloat const kCXHUDToastMargin = 8.0; // 间距单位大小
static CGFloat const kCXHUDToastIconSize = 30.0; // 图标的宽高
static CGFloat const kCXHUDToastFont = 14.0; // 字体大小
static CGFloat const kCXHUDToastLineHeight = 16.0; // 行高

@interface CXHUDConfiguration : NSObject

@end

NS_ASSUME_NONNULL_END
