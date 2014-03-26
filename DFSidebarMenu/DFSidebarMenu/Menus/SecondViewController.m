//
//  SecondViewController.m
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 09/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "SecondViewController.h"
#import "DFSidebarMenu.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"show");
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
            NSLog(@"viewDidAppear");
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
        NSLog(@"viewDidDisappear");
}

- (IBAction)showMenu:(id)sender
{
    [self.dfSidebarMenu showMenu];
}

@end
