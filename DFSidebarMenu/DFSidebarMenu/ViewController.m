//
//  ViewController.m
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 08/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "ViewController.h"
#import "DFSidebarMenu.h"
#import "FirstViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)goAction:(id)sender
{
    DFSidebarMenu* sideBarMenu = [[DFSidebarMenu alloc] initWithBackgroundImage:[UIImage imageNamed:@"clear-bedroom-1136x640" ] andMenus:[self menus]];
    sideBarMenu.sideBarBlurType = DFSideBarBlurTypeDark;
    [self presentViewController:sideBarMenu animated:YES completion:nil];
}

- (NSArray*) menus
{
    UIViewController* first = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    UIViewController* second = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
        UIViewController* third = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdViewController"];
    NSDictionary* menu1 = @{DFSidebarViewController : first, DFSidebarMenuTitle: @"First"};
    NSDictionary* menu2 = @{DFSidebarViewController : second, DFSidebarMenuTitle: @"Second", DFSidebarMenuIcon: @"settings"};
    NSDictionary* menu3 = @{DFSidebarViewController : third, DFSidebarMenuTitle: @"Third"};
    return @[menu1,menu2,menu3];
}

@end
