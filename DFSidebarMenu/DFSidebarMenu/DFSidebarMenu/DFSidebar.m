//
//  DFSidebar.m
//  DFSidebarMenu
//
//  Created by Kiss Tamás on 08/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "DFSidebar.h"

@interface DFSidebar ()
@property (nonatomic,strong) NSArray* menus;
@end

@implementation DFSidebar

- (id)initWithViewMenus:(NSArray*)menus
{
    self = [super init];
    if (self) {
        _menus = menus;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void) setupUI
{
    UINib* cellNib = [UINib nibWithNibName:@"DFSidebarCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"DFSidebarCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        UIEdgeInsets insets = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFSidebarCell* dfCell = (DFSidebarCell*)cell;
    dfCell.titleLabel.alpha = 0;
    CATransform3D scale = CATransform3DIdentity;
    scale = CATransform3DScale(scale, 0.6, 0.6, 1);
    dfCell.circleView.layer.transform = scale;
    scale = CATransform3DIdentity;
    [UIView animateWithDuration:.7 animations:^{
        dfCell.titleLabel.alpha = 1.0f;
        dfCell.circleView.layer.transform = scale;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DFSidebarCell";
    DFSidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DFSidebarCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* menu = self.menus[indexPath.row];
    cell.titleLabel.text = menu[DFSidebarMenuTitle];
    cell.titleLabel.textColor = self.textColor;
    cell.iconBtn.hidden = YES;
    if (menu[DFSidebarMenuIcon]) {
        UIImage *image = [UIImage imageNamed:menu[DFSidebarMenuIcon]];
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending && self.iconColor) {
            cell.icon.hidden = YES;
            cell.iconBtn.hidden = NO;
            if (self.iconColor) {
                cell.iconBtn.tintColor = self.iconColor;
            }
            [cell.iconBtn setImage:image forState:UIControlStateNormal];
            cell.iconBtn.userInteractionEnabled = NO;
        } else {
            cell.icon.image = image;
            cell.iconBtn.hidden = YES;
        }
        
    }
    cell.circleView.circleColor = self.circleColor;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectMenu:indexPath.row];
}

@end

@interface DFSidebarCell()
@property (strong,nonatomic) UIColor *tempCircleColor;
@end

@implementation DFSidebarCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    CATransform3D scale = CATransform3DIdentity;
    if (highlighted) {
        self.tempCircleColor = self.circleView.circleColor;
        [self.circleView setCircleColor:[UIColor colorWithRed:(100.f/255.f) green:(100.f/255.f) blue:(100.f/255.f) alpha:1.0]];
        scale = CATransform3DScale(scale, 0.9, 0.9, 1);
    } else {
        if (self.tempCircleColor) {
            [self.circleView setCircleColor:self.tempCircleColor];
        }
    }
    [UIView animateWithDuration:0.1 animations:^(){
        self.circleView.layer.transform = scale;
    }];
}

@end

@implementation DFSidebarCircleView

- (void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, self.circleColor.CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGRect circle = CGRectMake(2, 2, CGRectGetMaxX(rect) - 4, CGRectGetMaxY(rect) - 4);
    CGContextAddEllipseInRect(ctx, circle);
    CGContextStrokePath(ctx);
}

- (void) setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

@end
