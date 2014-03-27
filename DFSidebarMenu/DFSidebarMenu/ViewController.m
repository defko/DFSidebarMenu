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
    MenuViewController* sideBarMenu = [[MenuViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"clear-bedroom-1136x640" ]];
    sideBarMenu.sideBarBlurType = DFSideBarBlurTypeLight;
    [self presentViewController:sideBarMenu animated:YES completion:nil];
}



@end
