//
//  iTVNavigationController.m
//  iTV
//
//  Created by Ahmed Farghaly on 7/5/14.
//  Copyright (c) 2014 Ahmed Farghaly. All rights reserved.
//

#import "iTVNavigationController.h"
#import "iTVMasterViewController.h"
#import "iTVDetailViewController.h"
#import "DeviceUtils.h"

@interface iTVNavigationController ()

@end



// - - - - - - - - - - - -



@implementation iTVNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (BOOL)shouldAutorotate
{
    BOOL should = NO;
    
    // For iPhones, iTVMasterViewController determines rotation
    if(DeviceIsiPhone())
    {
        iTVMasterViewController *masterViewController = (iTVMasterViewController *)self.topViewController;
        should = [masterViewController shouldAutorotate];
    }
    // For iPads, iDetailViewController determines rotation
    else if(DeviceIsiPad())
    {
        iTVDetailViewController *detailViewController = (iTVDetailViewController *)self.topViewController;
        should = [detailViewController shouldAutorotate];
    }
    
    return should;
}


-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}



@end
