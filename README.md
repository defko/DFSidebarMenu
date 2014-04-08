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
