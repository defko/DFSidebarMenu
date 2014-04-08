DFSidebarMenu
=============

Good looking menu

Setup
----------
Add DFSidebarMenu folder to your project folder.

You have to override the DFSideBarMenu controller

For example:

```objectivec
@interface MenuViewController : DFSidebarMenu
```

and next you initialize with:

```objectivec
MenuViewController* sideBarMenu = [[MenuViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"background"]];
```

In the overrided class you will find a method dataSourceForSideBarMenu, where you can set the datasource
(Yeah I know it is pretty ugly, I will fix this later)

```objectivec
- (id<DFSidebarDataSource>) dataSourceForSideBarMenu
{
    return self;
}
```

In datasource you can have to set the following
```objectivec
- (NSInteger) numberOfMenus
```
viewController at index. Identifier identify the right viewcontroller at index. We need this if we for exmaple want to change the viewcontroller at index 0.
```objectivec
- (UIViewController*) viewControllerAtIndex:(NSInteger) menuIndex withIdentifier:(NSString*)identifier
```
It will called only once when a viewcontroller created. If you want change something every menu changed you can use
the following method
```objectivec
- (void) selectedViewController:(UIViewController*) viewController atIndex:(NSInteger) menuIndex;
```

Identifier at index. 
```objectivec
- (NSString*) identifierAtIndex:(NSInteger) menuIndex
```

There is some other setter method
```objectivec
- (NSString*) titleAtIndex:(NSInteger) menuIndex;
- (UIImage*) imageAtIndex:(NSInteger) menuIndex;
- (BOOL) shouldSelectMenuAtIndex:(NSInteger) menuIndex;
```

Properties to customize menu
@property (nonatomic,strong) UIColor *circleColor;
/*It works only on iOS7*/
@property (nonatomic,strong) UIColor *iconColor;
@property (nonatomic,strong) UIColor *textColor;
/*You can change the blur type*/
@property (nonatomic,assign) DFSideBarBlurType sideBarBlurType;
@property (nonatomic,assign) CGFloat blurRadius;
/*Add blur effect to sidebar*/
@property (nonatomic,assign) BOOL blurSideBar;
/*Add blur effect to background*/
@property (nonatomic,assign) BOOL blurBackground;
