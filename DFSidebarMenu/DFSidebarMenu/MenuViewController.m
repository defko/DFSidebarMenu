//
//  MenuViewController.m
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 27/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()<DFSidebarDataSource>
@property (nonatomic,strong) NSArray* menu;
@end

@implementation MenuViewController


- (void)viewDidLoad
{
    self.menu = [self menus];
    [super viewDidLoad];
}

- (NSArray*) menus
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* first = [storyBoard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    UIViewController* second = [storyBoard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    UIViewController* third = [storyBoard instantiateViewControllerWithIdentifier:@"ThirdViewController"];
    NSDictionary* menu1 = @{DFSidebarViewController : first,  DFSidebarMenuIdentifier:@"FirstViewController",  DFSidebarMenuTitle: @"First"};
    NSDictionary* menu2 = @{DFSidebarViewController : second, DFSidebarMenuIdentifier:@"SecondViewController", DFSidebarMenuTitle: @"Second", DFSidebarMenuIcon: @"settings"};
    NSDictionary* menu3 = @{DFSidebarViewController : third,  DFSidebarMenuIdentifier:@"ThirdViewController",  DFSidebarMenuTitle: @"Third"};
    return @[menu1,menu2,menu3];
}

- (id<DFSidebarDataSource>) dataSourceForSideBarMenu
{
    return self;
}

- (NSInteger) numberOfMenus
{
    return self.menu.count;
}

- (NSString*) identifierAtIndex:(NSInteger) menuIndex
{
    NSDictionary* menu = self.menu[menuIndex];
    return menu[DFSidebarMenuIdentifier];
}

- (UIViewController*) viewControllerAtIndex:(NSInteger) menuIndex withIdentifier:(NSString*)identifier
{
    NSDictionary* menu = self.menu[menuIndex];
    return menu[DFSidebarViewController];
}

@end
