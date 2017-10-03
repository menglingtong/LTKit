//
//  LTUIAlertController.m
//  LTKit
//
//  Created by 孟令通 on 2017/10/1.
//  Copyright © 2017年 LryMlt. All rights reserved.
//

#import "LTUIAlertController.h"

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

static NSUInteger alertControllerCount = 0;

#pragma mark - QMUIBUttonWrapView

@interface LTUIAlertButtonWrapView : UIView

//@property(nonatomic, strong) QMUIButton *button;

@end

@implementation LTUIAlertButtonWrapView

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.button = [[QMUIButton alloc] init];
//        self.button.adjustsButtonWhenDisabled = NO;
//        self.button.adjustsButtonWhenHighlighted = NO;
//        [self addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.button.frame = self.bounds;
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
//        [self.button addTarget:self action:@selector(handleAlertActionEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//- (QMUIButton *)button {
//    return self.buttonWrapView.button;
//}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
//    self.button.enabled = enabled;
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
//@property(nonatomic, strong) QMUIAlertAction *cancelAction;

//@property(nonatomic, strong) NSMutableArray<QMUIAlertAction *> *alertActions;
//@property(nonatomic, strong) NSMutableArray<QMUIAlertAction *> *destructiveActions;
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
        
//        self.alertActions = [[NSMutableArray alloc] init];
        self.alertTextFields = [[NSMutableArray alloc] init];
//        self.destructiveActions = [[NSMutableArray alloc] init];
        
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
    // Do any additional setup after loading the view.
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
