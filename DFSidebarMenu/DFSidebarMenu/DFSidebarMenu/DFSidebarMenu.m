//
//  DFSidebarMenu.m
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 08/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "DFSidebarMenu.h"
#import <objc/runtime.h>
#import "DFSidebar.h"
#import "UIImage+ImageEffects.h"

@interface DFSidebarMenu()

@property (nonatomic,strong) NSMutableDictionary* menuViewControllers;

@property (nonatomic,strong) UIViewController* centerController;
@property (nonatomic,assign) NSInteger lastSelectedMenu;
@property (nonatomic,strong) DFSidebar* sideBar;

@property (nonatomic,strong) UIButton* centerButton;
@property (nonatomic,strong) UIImageView* backgroundImageView;
@property (nonatomic,assign) NSTimeInterval animationDuration;

@property (nonatomic,weak) id dataSource;

@end

NSString* const DFSidebarViewController = @"DFSidebarViewController";
NSString* const DFSidebarMenuIcon  = @"DFSidebarMenuIcon";
NSString* const DFSidebarMenuTitle = @"DFSidebarMenuTitle";
NSString* const DFSidebarMenuIdentifier = @"DFSidebarMenuIdentifier";

@implementation DFSidebarMenu

#pragma mark - Init

- (instancetype) initWithBackgroundImage:(UIImage*)image
{
    self = [super init];
    if (self) {
        _backgroundImage = image;
        _animationDuration = 0.3;
        _blurRadius = 3.f;
        _menuViewControllers = [NSMutableDictionary new];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [self dataSourceForSideBarMenu];
    [self setupUI];
}

- (id<DFSidebarDataSource>) dataSourceForSideBarMenu
{
    return nil;
}

- (void) setupUI
{
    CGRect selfFrame = self.view.frame;

    self.sideBar = [DFSidebar new];
    self.sideBar.delegate = self;
    self.sideBar.dataSource = self.dataSource;
    self.sideBar.textColor = self.textColor;
    self.sideBar.circleColor = self.circleColor;
    self.sideBar.iconColor = self.iconColor;
    self.sideBar.view.frame = CGRectMake(-80, 0, 80, CGRectGetMaxY(selfFrame));
    [self addController:self.sideBar isMenu:NO];
    [self.sideBar.view removeFromSuperview];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    self.backgroundImageView.frame = CGRectMake(0, 0, CGRectGetMaxX(selfFrame), CGRectGetMaxY(selfFrame));
    [self.view addSubview:self.backgroundImageView];
    
    UIViewController* controller = [self viewControllerAtIndex:0];
    [self addViewController:controller];
  
    if (self.sideBarBlurType != DFSideBarBlurTypeNone) {
        [self performSelector:@selector(updateBlurEffectInBackground) withObject:nil afterDelay:0.1];
    }
    self.lastSelectedMenu = 0;
}

- (void) addViewController:(UIViewController*) controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navcon = (UINavigationController*)controller;
        UIViewController *viewCon = navcon.topViewController;
        viewCon.dfSidebarMenu = self;
    } else {
        controller.dfSidebarMenu = self;
    }
    [self addController:controller isMenu:YES];
    self.centerController = controller;
    [self addShadow:controller];
}

- (void) addController:(UIViewController*) controller isMenu:(BOOL)isMenu
{
    if (![controller parentViewController]) {
        [controller willMoveToParentViewController:self];
        [self addChildViewController:controller];
        [controller didMoveToParentViewController:self];
    }
    
    if (isMenu) {
        [self.view insertSubview:controller.view belowSubview:self.sideBar.view];
    } else {
        [self.view addSubview:self.sideBar.view];
    }
}

- (void) removeController:(UIViewController*) controller
{
    UIViewController* parent = [controller parentViewController];
    [controller.view removeFromSuperview];
     parent = [controller parentViewController];
}

- (void) addShadow: (UIViewController*) controller
{
    controller.view.layer.shadowOffset = CGSizeMake(2, 2);
    controller.view.layer.shadowRadius = 5;
    controller.view.layer.shadowOpacity = 0.8;
}

#pragma mark - DFSidebarDelegate

- (void) showMenu
{
    [self pushBackAnimation:self.centerController isShow:NO];
    [self showSideBar:YES];
}

- (void) hideMenu
{
    [self hideMenu:self.centerController];
}

- (void) hideMenu:(UIViewController*) controllerToShow
{
    [self pushBackAnimation:controllerToShow isShow:YES];
    [self showSideBar:NO];
}

- (void) selectMenu:(NSInteger)menuIndex
{
    if ([self shouldSelectMenu:menuIndex]) {
        if (self.lastSelectedMenu != menuIndex) {
            UIViewController *selectedController = [self viewControllerAtIndex:menuIndex];
            BOOL isNextMenu = self.lastSelectedMenu > menuIndex;
            [self slideOutController:self.centerController direction:isNextMenu];
            [self slideInController:selectedController direction:!isNextMenu];
            self.lastSelectedMenu = menuIndex;
        } else {
            [self hideMenu];
        }
    }
}

- (void) changeCenterController:(UIViewController*) centerController menuIndex:(NSInteger) menuIndex
{
    [self changeCenterController:centerController menuIndex:menuIndex animated:NO direction:NO];
}

- (void) changeCenterController:(UIViewController*) centerController menuIndex:(NSInteger) menuIndex animated:(BOOL) animated direction:(BOOL) isNext
{
    if (animated) {
        [self slideOutController:self.centerController direction:isNext];
        [self slideInController:centerController direction:!isNext];
    } else {
        [self removeController:self.centerController];
        [self addViewController:centerController];
    }
    self.lastSelectedMenu = menuIndex;
}

#pragma mark - DFSidebarDataSource

- (UIViewController*) viewControllerAtIndex:(NSInteger) index
{
    NSString* identifier = [self.dataSource identifierAtIndex:index];
    NSString* assertMsg = [NSString stringWithFormat:@"Identifier at index (%i) can not be nil",index];
    NSAssert(identifier, assertMsg);
    
    UIViewController *viewController = self.menuViewControllers[identifier];
    if (!viewController) {
        viewController = [self.dataSource viewControllerAtIndex:index withIdentifier:identifier];
        assertMsg = [NSString stringWithFormat:@"Viewcontroller at index (%i) with indentifier (%@) can not be nil",index,identifier];
        NSAssert(viewController, assertMsg);
        self.menuViewControllers[identifier] = viewController;
    } else {
        if ([self.dataSource respondsToSelector:@selector(selectedViewController:atIndex:)]) {
            [self.dataSource selectedViewController:viewController atIndex:index];
        }
    }
    return viewController;
}

- (UIViewController*) viewControllerAtIndex:(NSInteger)menuIndex withIdentifier:(NSString*)identifier
{
    UIViewController *viewController = self.menuViewControllers[identifier];
    return viewController;
}

- (BOOL) shouldSelectMenu:(NSInteger) menuIndex
{
    BOOL shouldSelect = YES;
    if ([self.dataSource respondsToSelector:@selector(shouldSelectMenuAtIndex:)]) {
        shouldSelect = [self.dataSource shouldSelectMenuAtIndex:menuIndex];
    }
    return shouldSelect;
}

#pragma mark - Animations

- (void) slideOutController:(UIViewController*) controller direction:(BOOL) isToLeft
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self slideOutControllerIOS7:controller direction:isToLeft];
    } else {
        [self slideOutControllerIOS61:controller direction:isToLeft];
    }
}

- (void) slideOutControllerIOS61:(UIViewController*) controller direction:(BOOL) isToLeft
{
    CATransform3D t1 = [self pushBackTransform1WithView:controller.view isLeft:!isToLeft];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        controller.view.layer.transform = t1;
    } completion:^(BOOL finished){
        [self slideOutControllerIOS62:controller direction:isToLeft];
    }];
}

- (void) slideOutControllerIOS62:(UIViewController*) controller direction:(BOOL) isToLeft
{
    CGRect frame = controller.view.frame;
    frame.origin.x = isToLeft ? self.view.frame.size.width * 1.2 : -self.view.frame.size.width * 1.2;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        controller.view.frame = frame;
    } completion:^(BOOL finished){
        [self removeController:controller];
    }];
}

- (void) slideOutControllerIOS7:(UIViewController*) controller direction:(BOOL) isToLeft
{
    CATransform3D t1 = [self pushBackTransform1WithView:controller.view isLeft:!isToLeft];
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
            controller.view.layer.transform = t1;
        }];
        CGRect frame = controller.view.frame;
        frame.origin.x = isToLeft ? self.view.frame.size.width * 1.2 : -self.view.frame.size.width * 1.2;
        [UIView addKeyframeWithRelativeStartTime:0.4f relativeDuration:0.6f animations:^{
            controller.view.frame = frame;
        }];
        
    } completion:^(BOOL finished) {
        [self removeController:controller];
    }];
}

- (void) slideInController:(UIViewController*) controller direction:(BOOL) isFromRight
{
    [self addViewController:controller];
    if (controller.view.bounds.size.width==self.view.bounds.size.width) {
        CATransform3D t1 = [self pushBackTransform1WithView:controller.view isLeft:!isFromRight];
        controller.view.layer.transform = t1;
    }
    CGRect frame = controller.view.frame;
    frame.origin.x = isFromRight ? self.view.frame.size.width*1.4 : -self.view.frame.size.width*1.2;
    controller.view.frame = frame;
    
    frame.origin.x = self.view.frame.size.width * 1.1 - frame.size.width;
    
    BOOL ios7 = [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending;
    NSTimeInterval duration = ios7 ? 0.6 : 0.7;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        controller.view.frame = frame;
    } completion:^(BOOL finished){
        [self hideMenu:controller];
    }];
}

-(void)pushBackAnimation:(UIViewController*) controller isShow:(BOOL) isShow
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self pushBackAnimationIOS7:controller isShow:isShow];
    } else {
        [self pushBackAnimationIOS6:controller isShow:isShow];
    }
}

- (void) pushBackAnimationIOS6:(UIViewController*) controller isShow:(BOOL) isShow
{
    CATransform3D t1 = [self pushBackTransform1WithView:controller.view isLeft:YES];
    [UIView animateWithDuration:self.animationDuration/2 animations:^{
        controller.view.layer.transform = t1;
    } completion:^(BOOL finished){
        [self pushBackAnimation2IOS6:controller isShow:isShow];
    }];
}

- (void) pushBackAnimation2IOS6:(UIViewController*) controller isShow:(BOOL) isShow
{
    CATransform3D t2 = isShow ? CATransform3DIdentity: [self pushBackTransform2WithView:controller.view];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:self.animationDuration/2 animations:^{
        controller.view.layer.transform = t2;
        if (isShow) {
            controller.view.frame = frame;
        }
    } completion:^(BOOL finished){
        if (isShow) {
            [self.centerButton removeFromSuperview];
        } else {
            [controller.view addSubview:[self getCenterButton]];
        }
    }];
}

- (void) pushBackAnimationIOS7:(UIViewController*) controller isShow:(BOOL) isShow
{
    CATransform3D t1 = [self pushBackTransform1WithView:controller.view isLeft:YES];
    CATransform3D t2 = isShow ? CATransform3DIdentity: [self pushBackTransform2WithView:controller.view];
    [UIView animateKeyframesWithDuration:self.animationDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
            controller.view.layer.transform = t1;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.5f animations:^{
            
            controller.view.layer.transform = t2;
            if (isShow) {
                controller.view.frame = self.view.frame;
            }
        }];
        
    } completion:^(BOOL finished) {
        if (isShow) {
            [self.centerButton removeFromSuperview];
        } else {
            [controller.view addSubview:[self getCenterButton]];
        }
    }];
}

- (void) showSideBar:(BOOL) isShow
{
    CGRect frame = self.sideBar.view.frame;
    frame.origin.x = isShow ? 0 : -frame.size.width;
    if (isShow) { [self.view addSubview:self.sideBar.view]; }
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.sideBar.view.frame = frame;
    } completion:^(BOOL isFinished){
        if (!isShow) { [self.sideBar.view removeFromSuperview]; }
    }];
}

- (CATransform3D) pushBackTransform1WithView:(UIView*)view isLeft:(BOOL) isLeft
{
    CATransform3D pushBack = CATransform3DIdentity;
    CGFloat offset = isLeft ? view.frame.size.width*0.2 : view.frame.size.width*0.3;
    pushBack = CATransform3DTranslate(pushBack, offset, 0.1, 0);
    pushBack = CATransform3DScale(pushBack, 0.8, 0.8, 1);
    return pushBack;
}

- (CATransform3D) pushBackTransform2WithView:(UIView*)view
{
    CATransform3D pushBack = CATransform3DIdentity;
    pushBack = CATransform3DTranslate(pushBack, view.frame.size.width*0.3, 0.1, 0);
    pushBack = CATransform3DScale(pushBack, 0.9, 0.9, 1);
    return pushBack;
}


- (UIButton*) getCenterButton
{
    if (!self.centerButton) {
        self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.centerButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.centerButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        [self.centerButton setBackgroundImage:nil forState:UIControlStateDisabled];
        self.centerButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.centerButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
        self.centerButton.backgroundColor = [UIColor clearColor];
        self.centerButton.accessibilityViewIsModal = YES;
    }
    self.centerButton.frame = [self.centerController.view bounds];
    return self.centerButton;
}

#pragma mark - Blur effect

- (void) updateBlurEffectInBackground
{
    self.sideBar.view.hidden = YES;
    UIImage* snapshot = [UIImage snapshotFromView:self.backgroundImageView withSize:self.sideBar.view.bounds];
    self.sideBar.view.hidden = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurImage = [snapshot blurredImageWithRadius:self.blurRadius withBlurType:self.sideBarBlurType];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setLayerContents:blurImage];
        });
    });
}

- (void)setLayerContents:(UIImage *)image
{
    self.sideBar.view.layer.contents = (id)image.CGImage;
    self.sideBar.view.layer.contentsScale = image.scale;
}

@end

@implementation UIViewController (DFSidebarWrapper)

- (id)dfSidebarMenu {
    return objc_getAssociatedObject(self, @selector(dfSidebarMenu));
}

- (void)setDfSidebarMenu:(id)dfSidebarMenu {
    objc_setAssociatedObject(self, @selector(dfSidebarMenu), dfSidebarMenu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIImage (DFBlurView)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius withBlurType:(DFSideBarBlurType) blurType
{
    UIImage* image = nil;
    switch (blurType) {
        case DFSideBarBlurTypeLight:
            image = [self applyLightEffect];
            break;
        case DFSideBarBlurTypeDark:
            image = [self applyDarkEffect];
            break;
        case DFSideBarBlurTypeNone:
            image = self;
            break;
    }
    if (!image) {
        NSLog(@"Image blurring result is nil");
    }
    return image;
}

+ (UIImage *)snapshotFromView:(UIView*)view withSize:(CGRect) bounds
{
    UIGraphicsBeginImageContext(bounds.size);
    UIImage* snapshot;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        snapshot = UIGraphicsGetImageFromCurrentImageContext();
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        snapshot = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return snapshot;
}

@end