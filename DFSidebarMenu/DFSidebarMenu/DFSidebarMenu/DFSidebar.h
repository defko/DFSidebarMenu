//
//  DFSidebar.h
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 08/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFSidebarMenu.h"

@interface DFSidebar : UITableViewController

@property (nonatomic,weak) id<DFSidebarDelegate> delegate;
@property (nonatomic,weak) id dataSource;
@property (nonatomic,strong) UIColor *circleColor;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *iconColor;

@end

@interface DFSidebarCircleView : UIView
@property (strong, nonatomic) UIColor* circleColor;
@end

@interface DFSidebarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet DFSidebarCircleView *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@end