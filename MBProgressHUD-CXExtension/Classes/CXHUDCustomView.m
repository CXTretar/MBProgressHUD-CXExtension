//
//  CXHUDCustomView.m
//  MBProgressHUD-CXExtension
//
//  Created by CXTretar on 2021/7/4.
//

#import "CXHUDCustomView.h"
#import <CoreText/CoreText.h>
#import "CXHUDConfiguration.h"

@interface CXHUDCustomView ()

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation CXHUDCustomView

#pragma mark - 🛩 ClassMethods

+ (void)initialize {
    [self registerIconfont];
}

+ (void)registerIconfont {
    NSString *fontPath = [[NSBundle bundleForClass:self.class].bundlePath stringByAppendingPathComponent:@"MBProgressHUD-CXExtension.bundle/icomoonfree.ttf"];
    NSData *fontData = [NSData dataWithContentsOfFile:fontPath];
    if (!fontData) {
        return;
    }
    
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
}

#pragma mark - 🚑 LifeCycle

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon image:(NSString *)image isLoading:(BOOL)isLoading {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 16;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.title = title;
        self.icon = icon;
        self.isLoading = isLoading;
        
        [self __setupSubView];
        
        if (isLoading) {
            [self __startAnimating];
        }
    }
    return self;
}

#pragma mark - 🚌 Public

#pragma mark - 🚓 UIEvents

#pragma mark - 👨‍👦Override

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.contentWidth,  self.contentHeight);
}

#pragma mark - 🚗 Private

- (UIImage *)__imageWithIcon:(NSString *)iconCode inFont:(NSString *)fontName size:(NSUInteger)size color:(UIColor *)color {
    CGSize imageSize = CGSizeMake(size, size);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    
    label.font = [UIFont fontWithName:fontName size:size];
    label.text = [self __changeToUnicode:[NSString stringWithFormat:@"\\U%@", iconCode]];
    if(color) {
        label.textColor = color;
    }
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return retImage;
}

- (NSString *)__changeToUnicode:(NSString *)aUnicodeString {
    
    NSString *tempStr = [aUnicodeString stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    tempStr = [[@"\"" stringByAppendingString:tempStr] stringByAppendingString:@"\""];
    //tempStr3现在的值为  @"\"\\uaaba\""
    NSData *tempData = [tempStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *resultStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    
    //通过NSPropertyListSerialization将NSData数据对象归档提取成String，这时候的resultStr就是 @"\uaaba"了
    return [resultStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (void)__startAnimating {
    if (self.iconImageView.superview) {
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 10000;
        [self.iconImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

#pragma mark - 🚲 Private - Setup

- (void)__setupSubView {
    if (self.icon.length || self.image.length || self.isLoading) {
        [self __setupTextAndIcon];
    }else {
        [self __setupOnlyText];
    }
}

- (void)__setupTextAndIcon {
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.minimumLineHeight = kCXHUDToastLineHeight;
    paragraphStyle.maximumLineHeight = kCXHUDToastLineHeight;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.title attributes:attributes];
    
    /// 计算文本宽度
    CGSize size = [self.title boundingRectWithSize:CGSizeMake(kCXHUDToastTextMaxWidth, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{
                                            NSFontAttributeName:[UIFont systemFontOfSize:kCXHUDToastFont],
                                            NSParagraphStyleAttributeName:paragraphStyle,
                                        }
                                           context:nil].size;
    
    // 修正文本宽度
    size.width = size.width < kCXHUDToastTextMinWidth ? kCXHUDToastTextMinWidth : size.width;
    size.width = size.width > kCXHUDToastTextMaxWidth - 5 ? kCXHUDToastTextMaxWidth : size.width;
    self.titleLabel.frame = CGRectMake(kCXHUDToastMargin, kCXHUDToastMargin + kCXHUDToastIconSize, size.width, size.height);
    [self addSubview:self.titleLabel];
    
    // 计算 ToastView 大小
    self.contentWidth = size.width + kCXHUDToastMargin * 2;
    self.contentHeight = size.height + kCXHUDToastMargin + kCXHUDToastMargin * 2 + kCXHUDToastIconSize;
    self.frame = CGRectMake(0, 0, self.contentWidth, self.contentHeight);
    
    // 设置图片
    if (self.image.length) {
        
    }else if (self.icon.length) {
        
        UIImage *image = [self __imageWithIcon:self.icon inFont:@"icomoonfree" size:kCXHUDToastIconSize color:[UIColor whiteColor]];
        self.iconImageView.image = image;
        self.iconImageView.frame = CGRectMake((self.contentWidth - kCXHUDToastIconSize) * 0.5, kCXHUDToastMargin, kCXHUDToastIconSize, kCXHUDToastIconSize);
        [self addSubview:self.iconImageView];
        
    }else if (self.isLoading) {
        
        self.activityView.frame = CGRectMake((self.contentWidth - kCXHUDToastIconSize) * 0.5, kCXHUDToastMargin, kCXHUDToastIconSize, kCXHUDToastIconSize);
        [self addSubview:self.activityView];
        [self.activityView startAnimating];
    }
}

- (void)__setupOnlyText {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.minimumLineHeight = kCXHUDToastLineHeight;
    paragraphStyle.maximumLineHeight = kCXHUDToastLineHeight;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.title attributes:attributes];
    
    /// 计算文本宽度
    CGSize size = [self.title boundingRectWithSize:CGSizeMake(kCXHUDToastTextMaxWidth, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{
                                            NSFontAttributeName:[UIFont systemFontOfSize:kCXHUDToastFont],
                                            NSParagraphStyleAttributeName:paragraphStyle,
                                        }
                                           context:nil].size;
    
    // 修正文本宽度
    size.width = size.width > kCXHUDToastTextMaxWidth - 5 ? kCXHUDToastTextMaxWidth : size.width;
    
    self.titleLabel.frame = CGRectMake(kCXHUDToastMargin * 3, kCXHUDToastMargin, size.width, size.height);
    [self addSubview:self.titleLabel];
    
    // 计算 ToastView 大小
    self.contentWidth = size.width + kCXHUDToastMargin * 6;
    self.contentHeight = size.height +  kCXHUDToastMargin * 2;
    self.frame = CGRectMake(0, 0, self.contentWidth, self.contentHeight);
}

#pragma mark - 🛴 Delegate

#pragma mark - 🛰 KVO

#pragma mark - 🚁 Notification

#pragma mark - 🚚 Custom Accessors

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:kCXHUDToastFont weight:UIFontWeightRegular];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCXHUDToastIconSize, kCXHUDToastIconSize)];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        _activityView.color = [UIColor whiteColor];
    }
    return _activityView;
}

@end
