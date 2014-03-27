//
//  FirstDetailViewController.m
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 27/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "FirstDetailViewController.h"
#import "DFSidebarMenu.h"

@interface FirstDetailViewController ()

@end

@implementation FirstDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)showMenu:(id)sender
{
    [self.dfSidebarMenu showMenu];
}


@end
