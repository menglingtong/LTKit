//
//  LTUIAlertController.h
//  LTKit
//
//  Created by 孟令通 on 2017/10/1.
//  Copyright © 2017年 LryMlt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LTUIAlertActionStyle) {
    LTUIAlertActionStyleDefault = 0,
    LTUIAlertActionStyleCancel,
    LTUIAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, LTUIAlertControllerStyle) {
    LTUIAlertControllerStyleActionSheet = 0,
    LTUIAlertControllerStyleAlert
};


/**
 *  QMUIAlertController的按钮，初始化完通过`QMUIAlertController`的`addAction:`方法添加到 AlertController 上即可。
 */
@interface LTUIAlertAction : NSObject

/**
 *  初始化`QMUIAlertController`的按钮
 *
 *  @param title   按钮标题
 *  @param style   按钮style，跟系统一样，有 Default、Cancel、Destructive 三种类型
 *  @param handler 处理点击时间的block
 *
 *  @return QMUIAlertController按钮的实例
 */
+ (instancetype)actionWithTitle:(NSString *)title style:(LTUIAlertActionStyle)style handler:(void (^)(LTUIAlertAction *action))handler;

/// `QMUIAlertAction`对应的 button 对象
//@property(nonatomic, strong, readonly) QMUIButton *button;

/// `QMUIAlertAction`对应的标题
@property(nonatomic, copy, readonly) NSString *title;

/// `QMUIAlertAction`对应的样式
@property(nonatomic, assign, readonly) LTUIAlertActionStyle style;

/// `QMUIAlertAction`是否允许操作
@property(nonatomic, assign, getter=isEnabled) BOOL enabled;

/// `QMUIAlertAction`按钮样式，默认nil。当此值为nil的时候，则使用`QMUIAlertController`的`alertButtonAttributes`或者`sheetButtonAttributes`的值。
@property(nonatomic, strong) NSDictionary<NSString *, id> *buttonAttributes;

/// 原理同上`buttonAttributes`
@property(nonatomic, strong) NSDictionary<NSString *, id> *buttonDisabledAttributes;

@end

@interface LTUIAlertController : UIViewController

/// alert距离屏幕四边的间距，默认UIEdgeInsetsMake(0, 0, 0, 0)。alert的宽度最终是通过屏幕宽度减去水平的 alertContentMargin 和 alertContentMaximumWidth 决定的。
@property(nonatomic, assign) UIEdgeInsets alertContentMargin UI_APPEARANCE_SELECTOR;

/// alert的最大宽度，默认270。
@property(nonatomic, assign) CGFloat alertContentMaximumWidth UI_APPEARANCE_SELECTOR;

/// alert上分隔线颜色，默认UIColorMake(211, 211, 219)。
@property(nonatomic, strong) UIColor *alertSeperatorColor UI_APPEARANCE_SELECTOR;

/// alert标题样式，默认@{NSForegroundColorAttributeName:UIColorBlack,NSFontAttributeName:UIFontBoldMake(17),NSParagraphStyleAttributeName:[NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:0 lineBreakMode:NSLineBreakByTruncatingTail]}
@property(nonatomic, strong) NSDictionary<NSString *, id> *alertTitleAttributes UI_APPEARANCE_SELECTOR;

/// alert信息样式，默认@{NSForegroundColorAttributeName:UIColorBlack,NSFontAttributeName:UIFontMake(13),NSParagraphStyleAttributeName:[NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:0 lineBreakMode:NSLineBreakByTruncatingTail]}
@property(nonatomic, strong) NSDictionary<NSString *, id> *alertMessageAttributes UI_APPEARANCE_SELECTOR;

/// alert按钮样式，默认@{NSForegroundColorAttributeName:UIColorBlue,NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)}
@property(nonatomic, strong) NSDictionary<NSString *, id> *alertButtonAttributes UI_APPEARANCE_SELECTOR;

/// alert按钮disabled时的样式，默认@{NSForegroundColorAttributeName:UIColorMake(129, 129, 129),NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)}
@property(nonatomic, strong) NSDictionary<NSString *, id> *alertButtonDisabledAttributes UI_APPEARANCE_SELECTOR;

/// alert cancel 按钮样式，默认@{NSForegroundColorAttributeName:UIColorBlue,NSFontAttributeName:UIFontBoldMake(17),NSKernAttributeName:@(0)}
@property(nonatomic, strong) NSDictionary<NSString *, id> *alertCancelButtonAttributes UI_APPEARANCE_SELECTOR;

/// alert destructive 按钮样式，默认@{NSForegroundColorAttributeName:UIColorRed,NSFontAttributeName:UIFontMake(17),NSKernAttributeName:@(0)}
@property(nonatomic, strong) NSDictionary<NSString *, id> *alertDestructiveButtonAttributes UI_APPEARANCE_SELECTOR;

/// alert圆角大小，默认值是：IOS_VERSION >= 9.0 ? 13 : 6，以保持与系统默认样式一致
@property(nonatomic, assign) CGFloat alertContentCornerRadius UI_APPEARANCE_SELECTOR;

/// alert按钮高度，默认44pt
@property(nonatomic, assign) CGFloat alertButtonHeight UI_APPEARANCE_SELECTOR;

/// alert头部（非按钮部分）背景色，默认值是：(IOS_VERSION < 8.0) ? UIColorWhite : UIColorMakeWithRGBA(247, 247, 247, 1)
@property(nonatomic, strong) UIColor *alertHeaderBackgroundColor UI_APPEARANCE_SELECTOR;

/// alert按钮背景色，默认值同`alertHeaderBackgroundColor`
@property(nonatomic, strong) UIColor *alertButtonBackgroundColor UI_APPEARANCE_SELECTOR;

/// alert按钮高亮背景色，默认UIColorMake(232, 232, 232)
@property(nonatomic, strong) UIColor *alertButtonHighlightBackgroundColor UI_APPEARANCE_SELECTOR;

/// alert头部四边insets间距
@property(nonatomic, assign) UIEdgeInsets alertHeaderInsets UI_APPEARANCE_SELECTOR;

/// alert头部title和message之间的间距，默认3pt
@property(nonatomic, assign) CGFloat alertTitleMessageSpacing UI_APPEARANCE_SELECTOR;



/// 默认初始化方法
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LTUIAlertControllerStyle)preferredStyle;

/// 通过类方法初始化实例
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LTUIAlertControllerStyle)preferredStyle;

/// @see `QMUIAlertControllerDelegate`
//@property(nonatomic,weak) id<LTUIAlertControllerDelegate>delegate;

/// 增加一个按钮
- (void)addAction:(LTUIAlertAction *)action;

/// 增加一个输入框
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

/// 增加一个自定义的view作为`QMUIAlertController`的customView
- (void)addCustomView:(UIView *)view;

/// 显示`QMUIAlertController`
- (void)showWithAnimated:(BOOL)animated;

/// 隐藏`QMUIAlertController`
- (void)hideWithAnimated:(BOOL)animated;

/// 所有`QMUIAlertAction`对象
@property(nonatomic, copy, readonly) NSArray <LTUIAlertAction *> *actions;

/// 当前所有通过`addTextFieldWithConfigurationHandler:`接口添加的输入框
//@property(nonatomic, copy, readonly) NSArray <QMUITextField *> *textFields;

/// 设置自定义view。通过`addCustomView:`方法添加一个自定义的view，`QMUIAlertController`会在布局的时候去掉用这个view的`sizeThatFits:`方法来获取size，至于x和y坐标则由控件自己控制。
@property(nonatomic, strong, readonly) UIView *customView;

/// 当前标题title
@property(nonatomic, copy) NSString *title;

/// 当前信息message
@property(nonatomic, copy) NSString *message;

/// 当前样式style
@property(nonatomic, assign, readonly) LTUIAlertControllerStyle preferredStyle;

/// 将`QMUIAlertController`弹出来的`QMUIModalPresentationViewController`对象
//@property(nonatomic, strong, readonly) LTUIModalPresentationViewController *modalPresentationViewController;

/**
 *  设置按钮的排序是否要由用户添加的顺序来决定，默认为NO，也即与系统原生`UIAlertController`一致，QMUIAlertActionStyleDestructive 类型的action必定在最后面。
 *
 *  @warning 注意 QMUIAlertActionStyleCancel 按钮不受这个属性的影响
 */
@property(nonatomic, assign) BOOL orderActionsByAddedOrdered;

/// maskView是否响应点击，alert默认为NO，sheet默认为YES
@property(nonatomic, assign) BOOL shouldRespondMaskViewTouch;

@end
