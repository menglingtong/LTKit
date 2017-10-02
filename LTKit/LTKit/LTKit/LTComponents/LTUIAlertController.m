//
//  LTUIAlertController.m
//  LTKit
//
//  Created by 孟令通 on 2017/10/1.
//  Copyright © 2017年 LryMlt. All rights reserved.
//

#import "LTUIAlertController.h"

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
        
        
    }
}


@end

#pragma mark - LTUIAlertController

@interface LTUIAlertController ()

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
