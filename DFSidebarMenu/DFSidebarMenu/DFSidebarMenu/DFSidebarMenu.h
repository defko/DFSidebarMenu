//
//  DFSidebarMenu.h
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 08/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DFSidebarDelegate

- (void) showMenu;
- (void) selectMenu:(NSInteger)menuIndex;
- (void) changeCenterControllerWithIdentifier:(NSString*)identifier menuIndex:(NSInteger) menuIndex;
- (void) changeCenterControllerWithIdentifier:(NSString*)identifier menuIndex:(NSInteger) menuIndex animated:(BOOL) animated direction:(BOOL) isNext;
@end

@protocol DFSidebarDataSource

@required
- (NSInteger) numberOfMenus;
- (NSString*) identifierAtIndex:(NSInteger) menuIndex;
- (UIViewController*) viewControllerAtIndex:(NSInteger) menuIndex withIdentifier:(NSString*)identifier;

@optional
- (NSString*) titleAtIndex:(NSInteger) menuIndex;
- (UIImage*) imageAtIndex:(NSInteger) menuIndex;
- (BOOL) shouldSelectMenuAtIndex:(NSInteger) menuIndex;
- (void) selectedViewController:(UIViewController*) viewController atIndex:(NSInteger) menuIndex;

@end

typedef NS_ENUM(NSInteger, DFSideBarBlurType) {
    DFSideBarBlurTypeNone = 0,
    DFSideBarBlurTypeLight = 1,
    DFSideBarBlurTypeDark= 2,
};

FOUNDATION_EXPORT NSString* const DFSidebarViewController;
FOUNDATION_EXPORT NSString* const DFSidebarMenuIcon;
FOUNDATION_EXPORT NSString* const DFSidebarMenuTitle;
FOUNDATION_EXPORT NSString* const DFSidebarMenuIdentifier;

@interface DFSidebarMenu : UIViewController<DFSidebarDelegate>

@property (nonatomic,strong) UIImage *backgroundImage;
@property (nonatomic,strong) UIColor *circleColor;
@property (nonatomic,strong) UIColor *iconColor;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,assign) DFSideBarBlurType sideBarBlurType;
@property (nonatomic,assign) CGFloat blurRadius;

- (instancetype) initWithBackgroundImage:(UIImage*)image;
- (id<DFSidebarDataSource>) dataSourceForSideBarMenu;

@end

@interface UIViewController (DFSidebarWrapper)

@property (nonatomic,weak) id<DFSidebarDelegate> dfSidebarMenu;

@end


@interface UIImage (DFBlurView)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius withBlurType:(DFSideBarBlurType) blurType;
+ (UIImage *)snapshotFromView:(UIView*)view withSize:(CGRect) bounds;
@end