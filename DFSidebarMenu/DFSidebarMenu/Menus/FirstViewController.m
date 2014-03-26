//
//  FirstViewController.m
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 08/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "FirstViewController.h"
#import "DFSidebarMenu.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)showMenu:(id)sender
{
    [self.dfSidebarMenu showMenu];
}

@end
