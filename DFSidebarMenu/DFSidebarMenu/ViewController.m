//
//  ViewController.m
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 08/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)goAction:(id)sender
{
    MenuViewController* sideBarMenu = [[MenuViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"background"]];
    sideBarMenu.sideBarBlurType = DFSideBarBlurTypeLight;
    sideBarMenu.textColor = [UIColor colorWithRed:(75/255.f) green:(75/255.) blue:(75/255.f) alpha:1];
    sideBarMenu.circleColor = [UIColor colorWithRed:(75/255.f) green:(75/255.) blue:(75/255.f) alpha:1];
    sideBarMenu.blurSideBar = NO;
    sideBarMenu.blurBackground = YES;
    [self presentViewController:sideBarMenu animated:YES completion:nil];
}



@end
