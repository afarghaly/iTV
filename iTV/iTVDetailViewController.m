//
//  iTVDetailViewController.m
//  iTV
//
//  Created by Ahmed Farghaly on 7/4/14.
//  Copyright (c) 2014 Ahmed Farghaly. All rights reserved.
//

#import "iTVDetailViewController.h"

@interface iTVDetailViewController ()
{
    iTVVideoView *videoView;
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end



// - - - - - - - - - - - - - - -



@implementation iTVDetailViewController


#pragma mark - UIViewController methods


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    videoView = [[iTVVideoView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    videoView.delegate = self;
    [self.view addSubview:videoView];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [videoView setNewFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}



// - - - - - - - - - - - - - - -



#pragma mark - UISplitViewControllerDelegate methods


- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Channels", @"Channels");
    barButtonItem.tintColor = [UIColor grayColor];
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}


- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}



// - - - - - - - - - - - - - - - - - -



- (void)closeMasterView
{
    [self.masterPopoverController dismissPopoverAnimated:YES];
}



// - - - - - - - - - - - - - - - - - -



- (void)playChannel:(NSDictionary *)channelData_
{
    self.title = channelData_[@"channelName"];
    [videoView playStream:channelData_[@"channelURL"]];
//    [videoView showVideoControls];
}



@end
