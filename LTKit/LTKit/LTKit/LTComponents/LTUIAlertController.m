//
//  LTUIAlertController.m
//  LTKit
//
//  Created by 孟令通 on 2017/10/1.
//  Copyright © 2017年 LryMlt. All rights reserved.
//

#import "LTUIAlertController.h"

#import "LTUICore.h"

#import "NSMutableParagraphStyle+LTKit.h"

// UIColor 相关的宏，用于快速创建一个 UIColor 对象，更多创建的宏可查看 UIColor+QMUI.h
#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

// 字体相关的宏，用于快速创建一个字体对象，更多创建宏可查看 UIFont+QMUI.h
#define UIFontMake(size) [UIFont systemFontOfSize:size]
#define UIFontItalicMake(size) [UIFont italicSystemFontOfSize:size] // 斜体只对数字和字母有效，中文无效
#define UIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]
#define UIFontBoldWithFont(_font) [UIFont boldSystemFontOfSize:_font.pointSize]

// 基础颜色
#define UIColorClear                [UIColor clearColor]
#define UIColorWhite                [UIColor whiteColor]
#define UIColorBlack                [UIColor blackColor]
#define UIColorGray                 [UIColor grayColor]
#define UIColorGrayDarken           [QMUICMI grayDarkenColor]
#define UIColorGrayLighten          [QMUICMI grayLightenColor]
#define UIColorRed                  [UIColor redColor]
#define UIColorGreen                [UIColor greenColor]
#define UIColorBlue                 [UIColor blueColor]
#define UIColorYellow               [UIColor yellowColor]

// 操作系统版本号
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])


#define ScreenScale ([[UIScreen mainScreen] scale])





static NSUInteger alertControllerCount = 0;

#pragma mark - QMUIBUttonWrapView

@interface LTUIAlertButtonWrapView : UIView

//@property(nonatomic, strong) QMUIButton *button;
@property (nonatomic, strong) UIButton *button;

@end

@implementation LTUIAlertButtonWrapView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.button = [[UIButton alloc] init];
        [self addSubview:self.button];
//        self.button = [[QMUIButton alloc] init];
//        self.button.adjustsButtonWhenDisabled = NO;
//        self.button.adjustsButtonWhenHighlighted = NO;
//        [self addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.bounds;
    
}

@end


#pragma mark - LTUIAlertAction

@protocol LTUIAlertActionDelegate <NSObject>

- (void)didClickAlertAction:(LTUIAlertAction *)alertAction;

@end

@interface LTUIAlertAction ()

@property(nonatomic, strong) LTUIAlertButtonWrapView *buttonWrapView;
@property(nonatomic, copy, readwrite) NSString *title;
@property(nonatomic, assign, readwrite) LTUIAlertActionStyle style;
@property(nonatomic, copy) void (^handler)(LTUIAlertAction *action);
@property(nonatomic, weak) id<LTUIAlertActionDelegate> delegate;

@end

@implementation LTUIAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(LTUIAlertActionStyle)style handler:(void (^)(LTUIAlertAction *action))handler {
    LTUIAlertAction *alertAction = [[LTUIAlertAction alloc] init];
    alertAction.title = title;
    alertAction.style = style;
    alertAction.handler = handler;
    return alertAction;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.buttonWrapView = [[LTUIAlertButtonWrapView alloc] init];
//        self.button.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
        [self.button addTarget:self action:@selector(handleAlertActionEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//- (QMUIButton *)button {
//    return self.buttonWrapView.button;
//}

- (UIButton *)button
{
    return self.buttonWrapView.button;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.button.enabled = enabled;
}

- (void)handleAlertActionEvent:(id)sender {
    // 需要先调delegate，里面会先恢复keywindow
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAlertAction:)]) {
        [self.delegate didClickAlertAction:self];
    }
    // 再调block回调
    if (self.handler) {
        self.handler(self);
    }
}

@end

@implementation LTUIAlertController (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self appearance];
    });
}
static LTUIAlertController *alertControllerAppearance;
+ (instancetype)appearance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self resetAppearance];
    });
    return alertControllerAppearance;
}

+ (void)resetAppearance {
    if (!alertControllerAppearance) {
        
        alertControllerAppearance = [[LTUIAlertController alloc] init];
        
#pragma mark - alert 默认样式
        alertControllerAppearance.alertContentMargin = UIEdgeInsetsMake(0, 0, 0, 0);
        alertControllerAppearance.alertContentMaximumWidth = 270;
        alertControllerAppearance.alertSeperatorColor = UIColorMake(211, 211, 219);
        alertControllerAppearance.alertTitleAttributes = @{NSForegroundColorAttributeName:UIColorBlack,NSFontAttributeName:UIFontBoldMake(17),NSParagraphStyleAttributeName:[NSMutableParagraphStyle ltKit_paragraphStyleWithLineHeight:0 lineBreakMode:NSLineBreakByTruncatingTail]};
        alertControllerAppearance.alertMessageAttributes = @{NSForegroundColorAttributeName:UIColorBlack,NSFontAttributeName:UIFontMake(13),NSParagraphStyleAttributeName:[NSMutableParagraphStyle ltKit_paragraphStyleWithLineHeight:0 lineBreakMode:NSLineBreakByTruncatingTail]};
        alertControllerAppearance.alertButtonAttributes = @{NSForegroundColorAttributeName:UIColorBlue,NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)};
        alertControllerAppearance.alertButtonDisabledAttributes = @{NSForegroundColorAttributeName:UIColorMake(129, 129, 129),NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)};
        alertControllerAppearance.alertCancelButtonAttributes = @{NSForegroundColorAttributeName:UIColorBlue,NSFontAttributeName:UIFontBoldMake(17),NSKernAttributeName:@(0)};
        alertControllerAppearance.alertDestructiveButtonAttributes = @{NSForegroundColorAttributeName:UIColorRed,NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)};
        alertControllerAppearance.alertContentCornerRadius = (IOS_VERSION >= 9.0 ? 13 : 6);
        alertControllerAppearance.alertButtonHeight = 44;
        alertControllerAppearance.alertHeaderBackgroundColor = (IOS_VERSION < 8.0) ? UIColorWhite : UIColorMakeWithRGBA(247, 247, 247, 1);
        alertControllerAppearance.alertButtonBackgroundColor = alertControllerAppearance.alertHeaderBackgroundColor;
        alertControllerAppearance.alertButtonHighlightBackgroundColor = UIColorMake(232, 232, 232);
        alertControllerAppearance.alertHeaderInsets = UIEdgeInsetsMake(20, 16, 20, 16);
        alertControllerAppearance.alertTitleMessageSpacing = 3;
        
#pragma mark - sheet
        
    }
}


@end

#pragma mark - LTUIAlertController

@interface LTUIAlertController ()

@property(nonatomic, assign, readwrite) LTUIAlertControllerStyle preferredStyle;
//@property(nonatomic, strong, readwrite) LTUIModalPresentationViewController *modalPresentationViewController;

@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIControl *maskView;

@property(nonatomic, strong) UIView *scrollWrapView;
@property(nonatomic, strong) UIScrollView *headerScrollView;
@property(nonatomic, strong) UIScrollView *buttonScrollView;

@property(nonatomic, strong) UIView *headerEffectView;
@property(nonatomic, strong) UIView *cancelButtoneEffectView;

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *messageLabel;
@property(nonatomic, strong) LTUIAlertAction *cancelAction;

@property(nonatomic, strong) NSMutableArray<LTUIAlertAction *> *alertActions;
@property(nonatomic, strong) NSMutableArray<LTUIAlertAction *> *destructiveActions;
@property(nonatomic, strong) NSMutableArray<UITextField *> *alertTextFields;

@property(nonatomic, assign) CGFloat keyboardHeight;
@property(nonatomic, assign) BOOL isShowing;

@end

@implementation LTUIAlertController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self didInitialized];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialized];
    }
    return self;
}

- (void)didInitialized
{
    self.alertContentMargin = [LTUIAlertController appearance].alertContentMargin;
    self.alertContentMaximumWidth = [LTUIAlertController appearance].alertContentMaximumWidth;
    self.alertSeperatorColor = [LTUIAlertController appearance].alertSeperatorColor;
    self.alertContentCornerRadius = [LTUIAlertController appearance].alertContentCornerRadius;
    self.alertTitleAttributes = [LTUIAlertController appearance].alertTitleAttributes;
    self.alertMessageAttributes = [LTUIAlertController appearance].alertMessageAttributes;
    self.alertButtonAttributes = [LTUIAlertController appearance].alertButtonAttributes;
    self.alertButtonDisabledAttributes = [LTUIAlertController appearance].alertButtonDisabledAttributes;
    self.alertCancelButtonAttributes = [LTUIAlertController appearance].alertCancelButtonAttributes;
    self.alertDestructiveButtonAttributes = [LTUIAlertController appearance].alertDestructiveButtonAttributes;
    self.alertButtonHeight = [LTUIAlertController appearance].alertButtonHeight;
    self.alertHeaderBackgroundColor = [LTUIAlertController appearance].alertHeaderBackgroundColor;
    self.alertButtonBackgroundColor = [LTUIAlertController appearance].alertButtonBackgroundColor;
    self.alertButtonHighlightBackgroundColor = [LTUIAlertController appearance].alertButtonHighlightBackgroundColor;
    self.alertHeaderInsets = [LTUIAlertController appearance].alertHeaderInsets;
    self.alertTitleMessageSpacing = [LTUIAlertController appearance].alertTitleMessageSpacing;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LTUIAlertControllerStyle)preferredStyle {
    LTUIAlertController *alertController = [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
    if (alertController) {
        return alertController;
    }
    return nil;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LTUIAlertControllerStyle)preferredStyle {
    self = [self init];
    if (self) {
        
        self.isShowing = NO;
        self.shouldRespondMaskViewTouch = preferredStyle == LTUIAlertControllerStyleActionSheet;
        
        self.alertActions = [[NSMutableArray alloc] init];
        self.alertTextFields = [[NSMutableArray alloc] init];
        self.destructiveActions = [[NSMutableArray alloc] init];
        
        self.containerView = [[UIView alloc] init];
        
        self.maskView = [[UIControl alloc] init];
        self.maskView.alpha = 0;
        self.maskView.backgroundColor = [UIColor blackColor];
        [self.maskView addTarget:self action:@selector(handleMaskViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        self.scrollWrapView = [[UIView alloc] init];
        self.headerEffectView = [[UIView alloc] init];
        self.cancelButtoneEffectView = [[UIView alloc] init];
        self.headerScrollView = [[UIScrollView alloc] init];
        self.buttonScrollView = [[UIScrollView alloc] init];
        
        self.title = title;
        self.message = message;
        self.preferredStyle = preferredStyle;
        
//        [self updateHeaderBackgrondColor];
//        [self updateEffectBackgroundColor];
//        [self updateCornerRadius];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.scrollWrapView];
    [self.scrollWrapView addSubview:self.headerEffectView];
    [self.scrollWrapView addSubview:self.headerScrollView];
    [self.scrollWrapView addSubview:self.buttonScrollView];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    BOOL hasTitle = (self.titleLabel.text && ![self.titleLabel.text isEqualToString:@""] && !self.titleLabel.hidden);
    BOOL hasMessage = (self.messageLabel.text && ![self.messageLabel.text isEqualToString:@""] && !self.messageLabel.hidden);
    BOOL hasTextField = self.alertTextFields.count > 0;
    BOOL hasCustomView = !!_customView;
    CGFloat contentOriginY = 0;
    
    self.maskView.frame = self.view.bounds;
    
    if (self.preferredStyle == LTUIAlertControllerStyleAlert) {
        
        CGFloat contentPaddingLeft = self.alertHeaderInsets.left;
        CGFloat contentPaddingRight = self.alertHeaderInsets.right;
        
        CGFloat contentPaddingTop = (hasTitle || hasMessage || hasTextField || hasCustomView) ? self.alertHeaderInsets.top : 0;
        CGFloat contentPaddingBottom = (hasTitle || hasMessage || hasTextField || hasCustomView) ? self.alertHeaderInsets.bottom : 0;
        self.containerView.width = fmin(self.alertContentMaximumWidth, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(self.alertContentMargin));
        self.scrollWrapView.width = CGRectGetWidth(self.containerView.bounds);
        self.headerScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollWrapView.bounds), 0);
        contentOriginY = contentPaddingTop;
        // 标题和副标题布局
        if (hasTitle) {
            CGFloat titleLabelLimitWidth = CGRectGetWidth(self.headerScrollView.bounds) - contentPaddingLeft - contentPaddingRight;
            CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(titleLabelLimitWidth, CGFLOAT_MAX)];
            self.titleLabel.frame = CGRectFlatted(CGRectMake(contentPaddingLeft, contentOriginY, titleLabelLimitWidth, titleLabelSize.height));
            contentOriginY = CGRectGetMaxY(self.titleLabel.frame) + (hasMessage ? self.alertTitleMessageSpacing : contentPaddingBottom);
        }
        if (hasMessage) {
            CGFloat messageLabelLimitWidth = CGRectGetWidth(self.headerScrollView.bounds) - contentPaddingLeft - contentPaddingRight;
            CGSize messageLabelSize = [self.messageLabel sizeThatFits:CGSizeMake(messageLabelLimitWidth, CGFLOAT_MAX)];
            self.messageLabel.frame = CGRectFlatted(CGRectMake(contentPaddingLeft, contentOriginY, messageLabelLimitWidth, messageLabelSize.height));
            contentOriginY = CGRectGetMaxY(self.messageLabel.frame) + contentPaddingBottom;
        }
        // 输入框布局
        if (hasTextField) {
            for (int i = 0; i < self.alertTextFields.count; i++) {
                UITextField *textField = self.alertTextFields[i];
                textField.frame = CGRectMake(contentPaddingLeft, contentOriginY, CGRectGetWidth(self.headerScrollView.bounds) - contentPaddingLeft - contentPaddingRight, 25);
                contentOriginY = CGRectGetMaxY(textField.frame) - 1;
            }
            contentOriginY += 16;
        }
        // 自定义view的布局 - 自动居中
        if (hasCustomView) {
            CGSize customViewSize = [_customView sizeThatFits:CGSizeMake(CGRectGetWidth(self.headerScrollView.bounds), CGFLOAT_MAX)];
            _customView.frame = CGRectFlatted(CGRectMake((CGRectGetWidth(self.headerScrollView.bounds) - customViewSize.width) / 2, contentOriginY, customViewSize.width, customViewSize.height));
            contentOriginY = CGRectGetMaxY(_customView.frame) + contentPaddingBottom;
        }
        // 内容scrollView的布局
        self.headerScrollView.frame = CGRectSetHeight(self.headerScrollView.frame, contentOriginY);
        self.headerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.headerScrollView.bounds), contentOriginY);
        contentOriginY = CGRectGetMaxY(self.headerScrollView.frame);
        // 按钮布局
        self.buttonScrollView.frame = CGRectMake(0, contentOriginY, CGRectGetWidth(self.containerView.bounds), 0);
        contentOriginY = 0;
//        NSArray *newOrderActions = [self orderedAlertActions:self.alertActions];
//        if (self.alertActions.count > 0) {
//            BOOL verticalLayout = YES;
//            if (self.alertActions.count == 2) {
//                CGFloat halfWidth = CGRectGetWidth(self.buttonScrollView.bounds) / 2;
//                LTUIAlertAction *action1 = newOrderActions[0];
//                LTUIAlertAction *action2 = newOrderActions[1];
//                CGSize actionSize1 = [action1.button sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//                CGSize actionSize2 = [action2.button sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//                if (actionSize1.width < halfWidth && actionSize2.width < halfWidth) {
//                    verticalLayout = NO;
//                }
//            }
//            if (!verticalLayout) {
//                LTUIAlertAction *action1 = newOrderActions[1];
//                action1.buttonWrapView.frame = CGRectMake(0, contentOriginY + PixelOne, CGRectGetWidth(self.buttonScrollView.bounds) / 2, self.alertButtonHeight);
//                LTUIAlertAction *action2 = newOrderActions[0];
//                action2.buttonWrapView.frame = CGRectMake(CGRectGetMaxX(action1.buttonWrapView.frame) + PixelOne, contentOriginY + PixelOne, CGRectGetWidth(self.buttonScrollView.bounds) / 2 - PixelOne, self.alertButtonHeight);
//                contentOriginY = CGRectGetMaxY(action1.buttonWrapView.frame);
//            }
//            else {
//                for (int i = 0; i < newOrderActions.count; i++) {
//                    LTUIAlertAction *action = newOrderActions[i];
//                    action.buttonWrapView.frame = CGRectMake(0, contentOriginY + PixelOne, CGRectGetWidth(self.containerView.bounds), self.alertButtonHeight - PixelOne);
//                    contentOriginY = CGRectGetMaxY(action.buttonWrapView.frame);
//                }
//            }
//        }
        // 按钮scrollView的布局
        self.buttonScrollView.frame = CGRectSetHeight(self.buttonScrollView.frame, contentOriginY);
        self.buttonScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.buttonScrollView.bounds), contentOriginY);
        // 容器最后布局
        CGFloat contentHeight = CGRectGetHeight(self.headerScrollView.bounds) + CGRectGetHeight(self.buttonScrollView.bounds);
        CGFloat screenSpaceHeight = CGRectGetHeight(self.view.bounds);
        if (contentHeight > screenSpaceHeight - 20) {
            screenSpaceHeight -= 20;
            CGFloat contentH = fmin(CGRectGetHeight(self.headerScrollView.bounds), screenSpaceHeight / 2);
            CGFloat buttonH = fmin(CGRectGetHeight(self.buttonScrollView.bounds), screenSpaceHeight / 2);
            if (contentH >= screenSpaceHeight / 2 && buttonH >= screenSpaceHeight / 2) {
                self.headerScrollView.frame = CGRectSetHeight(self.headerScrollView.frame, screenSpaceHeight / 2);
                self.buttonScrollView.frame = CGRectSetY(self.buttonScrollView.frame, CGRectGetMaxY(self.headerScrollView.frame));
                self.buttonScrollView.frame = CGRectSetHeight(self.buttonScrollView.frame, screenSpaceHeight / 2);
            } else if (contentH < screenSpaceHeight / 2) {
                self.headerScrollView.frame = CGRectSetHeight(self.headerScrollView.frame, contentH);
                self.buttonScrollView.frame = CGRectSetY(self.buttonScrollView.frame, CGRectGetMaxY(self.headerScrollView.frame));
                self.buttonScrollView.frame = CGRectSetHeight(self.buttonScrollView.frame, screenSpaceHeight - contentH);
            } else if (buttonH < screenSpaceHeight / 2) {
                self.headerScrollView.frame = CGRectSetHeight(self.headerScrollView.frame, screenSpaceHeight - buttonH);
                self.buttonScrollView.frame = CGRectSetY(self.buttonScrollView.frame, CGRectGetMaxY(self.headerScrollView.frame));
                self.buttonScrollView.frame = CGRectSetHeight(self.buttonScrollView.frame, buttonH);
            }
            contentHeight = CGRectGetHeight(self.headerScrollView.bounds) + CGRectGetHeight(self.buttonScrollView.bounds);
            screenSpaceHeight += 20;
        }
        self.scrollWrapView.frame =  CGRectMake(0, 0, CGRectGetWidth(self.scrollWrapView.bounds), contentHeight);
        self.headerEffectView.frame = self.scrollWrapView.bounds;
        
        CGRect containerRect = CGRectMake((CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.containerView.bounds)) / 2, (screenSpaceHeight - contentHeight - self.keyboardHeight) / 2, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.scrollWrapView.bounds));
        self.containerView.frame = CGRectFlatted(CGRectApplyAffineTransform(containerRect, self.containerView.transform));
    }
    
    else if (self.preferredStyle == LTUIAlertControllerStyleActionSheet) {
        
        CGFloat contentPaddingLeft = self.alertHeaderInsets.left;
        CGFloat contentPaddingRight = self.alertHeaderInsets.right;
        
        CGFloat contentPaddingTop = (hasTitle || hasMessage || hasTextField) ? self.sheetHeaderInsets.top : 0;
        CGFloat contentPaddingBottom = (hasTitle || hasMessage || hasTextField) ? self.sheetHeaderInsets.bottom : 0;
        self.containerView.width = fmin(self.sheetContentMaximumWidth, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(self.sheetContentMargin));
        self.scrollWrapView.width = CGRectGetWidth(self.containerView.bounds);
        self.headerScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 0);
        contentOriginY = contentPaddingTop;
        // 标题和副标题布局
        if (hasTitle) {
            CGFloat titleLabelLimitWidth = CGRectGetWidth(self.headerScrollView.bounds) - contentPaddingLeft - contentPaddingRight;
            CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(titleLabelLimitWidth, CGFLOAT_MAX)];
            self.titleLabel.frame = CGRectFlatted(CGRectMake(contentPaddingLeft, contentOriginY, titleLabelLimitWidth, titleLabelSize.height));
            contentOriginY = CGRectGetMaxY(self.titleLabel.frame) + (hasMessage ? self.sheetTitleMessageSpacing : contentPaddingBottom);
        }
        if (hasMessage) {
            CGFloat messageLabelLimitWidth = CGRectGetWidth(self.headerScrollView.bounds) - contentPaddingLeft - contentPaddingRight;
            CGSize messageLabelSize = [self.messageLabel sizeThatFits:CGSizeMake(messageLabelLimitWidth, CGFLOAT_MAX)];
            self.messageLabel.frame = CGRectFlatted(CGRectMake(contentPaddingLeft, contentOriginY, messageLabelLimitWidth, messageLabelSize.height));
            contentOriginY = CGRectGetMaxY(self.messageLabel.frame) + contentPaddingBottom;
        }
        // 自定义view的布局 - 自动居中
        if (hasCustomView) {
            CGSize customViewSize = [_customView sizeThatFits:CGSizeMake(CGRectGetWidth(self.headerScrollView.bounds), CGFLOAT_MAX)];
            _customView.frame = CGRectFlatted(CGRectMake((CGRectGetWidth(self.headerScrollView.bounds) - customViewSize.width) / 2, contentOriginY, customViewSize.width, customViewSize.height));
            contentOriginY = CGRectGetMaxY(_customView.frame) + contentPaddingBottom;
        }
        // 内容scrollView布局
        self.headerScrollView.frame = CGRectSetHeight(self.headerScrollView.frame, contentOriginY);
        self.headerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.headerScrollView.bounds), contentOriginY);
        contentOriginY = CGRectGetMaxY(self.headerScrollView.frame);
        // 按钮的布局
        self.buttonScrollView.frame = CGRectMake(0, contentOriginY, CGRectGetWidth(self.containerView.bounds), 0);
        contentOriginY = 0;
//        NSArray *newOrderActions = [self orderedAlertActions:self.alertActions];
        if (self.alertActions.count > 0) {
//            contentOriginY = (hasTitle || hasMessage || hasCustomView) ? contentOriginY + PixelOne : contentOriginY;
//            for (int i = 0; i < newOrderActions.count; i++) {
//                LTUIAlertAction *action = newOrderActions[i];
//                if (action.style == LTUIAlertActionStyleCancel && i == newOrderActions.count - 1) {
//                    continue;
//                } else {
//                    action.buttonWrapView.frame = CGRectMake(0, contentOriginY, CGRectGetWidth(self.buttonScrollView.bounds), self.sheetButtonHeight - PixelOne);
//                    contentOriginY = CGRectGetMaxY(action.buttonWrapView.frame) + PixelOne;
//                }
//            }
//            contentOriginY -= PixelOne;
        }
        // 按钮scrollView布局
        self.buttonScrollView.frame = CGRectSetHeight(self.buttonScrollView.frame, contentOriginY);
        self.buttonScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.buttonScrollView.bounds), contentOriginY);
        // 容器最终布局
        self.scrollWrapView.frame =  CGRectMake(0, 0, CGRectGetWidth(self.scrollWrapView.bounds), CGRectGetMaxY(self.buttonScrollView.frame));
        self.headerEffectView.frame = self.scrollWrapView.bounds;
        contentOriginY = CGRectGetMaxY(self.scrollWrapView.frame) + self.sheetCancelButtonMarginTop;
        if (self.cancelAction) {
            self.cancelButtoneEffectView.frame = CGRectMake(0, contentOriginY, CGRectGetWidth(self.containerView.bounds), self.sheetButtonHeight);
            self.cancelAction.buttonWrapView.frame = self.cancelButtoneEffectView.bounds;
            contentOriginY = CGRectGetMaxY(self.cancelButtoneEffectView.frame);
        }
        // 把上下的margin都加上用于跟整个屏幕的高度做比较
        CGFloat contentHeight = contentOriginY + UIEdgeInsetsGetVerticalValue(self.sheetContentMargin);
        CGFloat screenSpaceHeight = CGRectGetHeight(self.view.bounds);
        if (contentHeight > screenSpaceHeight) {
            CGFloat cancelButtonAreaHeight = (self.cancelAction ? (CGRectGetHeight(self.cancelAction.buttonWrapView.bounds) + self.sheetCancelButtonMarginTop) : 0);
            screenSpaceHeight = screenSpaceHeight - cancelButtonAreaHeight - UIEdgeInsetsGetVerticalValue(self.sheetContentMargin);
            CGFloat contentH = MIN(CGRectGetHeight(self.headerScrollView.bounds), screenSpaceHeight / 2);
            CGFloat buttonH = MIN(CGRectGetHeight(self.buttonScrollView.bounds), screenSpaceHeight / 2);
            if (contentH >= screenSpaceHeight / 2 && buttonH >= screenSpaceHeight / 2) {
                self.headerScrollView.frame = CGRectSetHeight(self.headerScrollView.frame, screenSpaceHeight / 2);
                self.buttonScrollView.frame = CGRectSetY(self.buttonScrollView.frame, CGRectGetMaxY(self.headerScrollView.frame));
                self.buttonScrollView.frame = CGRectSetHeight(self.buttonScrollView.frame, screenSpaceHeight / 2);
            } else if (contentH < screenSpaceHeight / 2) {
                self.headerScrollView.frame = CGRectSetHeight(self.headerScrollView.frame, contentH);
                self.buttonScrollView.frame = CGRectSetY(self.buttonScrollView.frame, CGRectGetMaxY(self.headerScrollView.frame));
                self.buttonScrollView.frame = CGRectSetHeight(self.buttonScrollView.frame, screenSpaceHeight - contentH);
            } else if (buttonH < screenSpaceHeight / 2) {
                self.headerScrollView.frame = CGRectSetHeight(self.headerScrollView.frame, screenSpaceHeight - buttonH);
                self.buttonScrollView.frame = CGRectSetY(self.buttonScrollView.frame, CGRectGetMaxY(self.headerScrollView.frame));
                self.buttonScrollView.frame = CGRectSetHeight(self.buttonScrollView.frame, buttonH);
            }
            self.scrollWrapView.frame =  CGRectSetHeight(self.scrollWrapView.frame, CGRectGetHeight(self.headerScrollView.bounds) + CGRectGetHeight(self.buttonScrollView.bounds));
            if (self.cancelAction) {
                self.cancelButtoneEffectView.frame = CGRectSetY(self.cancelButtoneEffectView.frame, CGRectGetMaxY(self.scrollWrapView.frame) + self.sheetCancelButtonMarginTop);
            }
            contentHeight = CGRectGetHeight(self.headerScrollView.bounds) + CGRectGetHeight(self.buttonScrollView.bounds) + cancelButtonAreaHeight + self.sheetContentMargin.bottom;
            screenSpaceHeight += (cancelButtonAreaHeight + UIEdgeInsetsGetVerticalValue(self.sheetContentMargin));
        } else {
            // 如果小于屏幕高度，则把顶部的top减掉
            contentHeight -= self.sheetContentMargin.top;
        }
        
        CGRect containerRect = CGRectMake((CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.containerView.bounds)) / 2, screenSpaceHeight - contentHeight, CGRectGetWidth(self.containerView.bounds), contentHeight);
        self.containerView.frame = CGRectFlatted(CGRectApplyAffineTransform(containerRect, self.containerView.transform));
    }
}

- (NSArray *)orderedAlertActions:(NSArray *)actions {
    NSMutableArray<LTUIAlertAction *> *newActions = [[NSMutableArray alloc] init];
    // 按照用户addAction的先后顺序来排序
    if (self.orderActionsByAddedOrdered) {
        [newActions addObjectsFromArray:self.alertActions];
        // 取消按钮不参与排序，所以先移除，在最后再重新添加
        if (self.cancelAction) {
            [newActions removeObject:self.cancelAction];
        }
    } else {
        for (LTUIAlertAction *action in self.alertActions) {
            if (action.style != LTUIAlertActionStyleCancel && action.style != LTUIAlertActionStyleDestructive) {
                [newActions addObject:action];
            }
        }
        for (LTUIAlertAction *action in self.destructiveActions) {
            [newActions addObject:action];
        }
    }
    if (self.cancelAction) {
        [newActions addObject:self.cancelAction];
    }
    return newActions;
}

- (void)addCustomView:(UIView *)view {
    if (self.alertTextFields.count > 0) {
        [NSException raise:@"QMUIAlertController使用错误" format:@"UITextField和CustomView不能共存"];
    }
    _customView = view;
    [self.headerScrollView addSubview:_customView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
