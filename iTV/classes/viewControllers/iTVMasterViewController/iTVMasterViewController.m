//
//  iTVMasterViewController.m
//  iTV
//
//  Created by Ahmed Farghaly on 7/4/14.
//  Copyright (c) 2014 Ahmed Farghaly. All rights reserved.
//

#import "iTVMasterViewController.h"
#import "iTVDetailViewController.h"
#import "DeviceUtils.h"



@interface iTVMasterViewController ()
{
    NSArray *channelsData;
    
    float screenHeight;
    UITableView *channelsTableView;
    BOOL isShowingVideo;
    UIBarButtonItem *closeBarButtonItem;
    
    iTVVideoView *videoView;
}

@end



// - - - - - - - - - - - -



@implementation iTVMasterViewController


#pragma mark - UIViewController methods



- (void)awakeFromNib
{
    if(DeviceIsiPad())
    {
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewController = (iTVDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // load channel data
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *channelsDataPath = [bundle pathForResource:@"channelsData" ofType:@"plist"];
    channelsData = [NSArray arrayWithContentsOfFile:channelsDataPath];
    
    screenHeight = DeviceIsiPad() ? self.view.frame.size.height : (DeviceIs4Inch() ? 504 : 416);
    
    channelsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                      DeviceIsiPad() ? 324 : 320,
                                                                      DeviceIsiPad() ? self.view.frame.size.height : screenHeight) style:UITableViewStylePlain];
    channelsTableView.dataSource = self;
    channelsTableView.delegate = self;
    [channelsTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:channelsTableView];
    
    closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonTapped)];
    closeBarButtonItem.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = DeviceIsiPad() ? closeBarButtonItem : nil;
    
    isShowingVideo = NO;
    
    // for iPhones, create inline video view
    if(DeviceIsiPhone())
    {
        videoView = [[iTVVideoView alloc] initWithFrame:CGRectMake(0, -240, 320, 240)];
        videoView.delegate = self;
        [self.view addSubview:videoView];
    }
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if(DeviceIsiPad())
    {
        channelsTableView.frame = CGRectMake(0, 0,
                                             DeviceIsiPad() ? 324 : 320,
                                             self.view.frame.size.height);
    }
    
}


- (BOOL)shouldAutorotate
{
    BOOL should = NO;
    
    if(isShowingVideo == YES || UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        should = YES;
    }
    else
    {
        should = NO;
    }
    
    return should;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        [self.navigationController setNavigationBarHidden:(DeviceIsiPad() ? NO : YES) animated:YES];
        [videoView setNewFrame:CGRectMake(0, 0, DeviceIs4Inch() ? 568 : 480,  320)];
    }
    else if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        CGRect channelsTableViewFrame = channelsTableView.frame;
        if(isShowingVideo == YES)
        {
            [videoView setNewFrame:CGRectMake(0, 0, 320, 240)];
            channelsTableViewFrame.origin.y = 240;
        }
        else
        {
            channelsTableViewFrame.origin.y = 0;
        }
        
        channelsTableView.frame = channelsTableViewFrame;
        [videoView hideVideoControls];
    }
}



// - - - - - - - - - - - -



#pragma mark - UITableViewDataSource methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [channelsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    for(UIView *view in [cell.contentView subviews])
    {
        [view removeFromSuperview];
    }
    
    cell.indentationLevel = 1.0;
    cell.indentationWidth = 100.0f;
    
    NSDictionary *channelData = channelsData[[indexPath row]];
    
    cell.textLabel.text = channelData[@"channelName"];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:26];
    
    UIView *shadowHighlightView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 40)];
    shadowHighlightView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.04f];
    [cell.contentView addSubview:shadowHighlightView];
    CALayer *shadowHighlightViewLayer = shadowHighlightView.layer;
    shadowHighlightViewLayer.cornerRadius = 5;
    shadowHighlightViewLayer.masksToBounds = YES;
    
    cell.detailTextLabel.text = channelData[@"channelCountry"];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    UIImageView *channelLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    channelLogoImageView.backgroundColor = [UIColor whiteColor];
    channelLogoImageView.image = [UIImage imageNamed:channelData[@"channelLogo"]];
    [cell.contentView addSubview:channelLogoImageView];
    CALayer *imageViewLayer = channelLogoImageView.layer;
    imageViewLayer.cornerRadius = 6.0f;
    imageViewLayer.masksToBounds = YES;
    
    return cell;
}



// - - - - - - - - - - - -



#pragma mark - UITableViewDelegate methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *channelData = [channelsData objectAtIndex:[indexPath row]];
    
    if(DeviceIsiPad())
    {
        //        NSDate *object = _objects[indexPath.row];
        //        self.detailViewController.detailItem = object;
        [self.detailViewController playChannel:channelData];
    }
    else if(DeviceIsiPhone())
    {
        self.title = channelData[@"channelName"];
        [videoView playStream:channelData[@"channelURL"]];
        [self showMiniVideoPlayer];
        [videoView hideVideoControls];
    }
}



// - - - - - - - - - - - -



#pragma mark - Mini-video player animations


- (void)showMiniVideoPlayer
{
    [UIView animateWithDuration:0.3f animations:^
     {
         channelsTableView.frame = CGRectMake(0, 240,
                                              DeviceIsiPad() ? 324 : 320,
                                              screenHeight - 240);
         
         [videoView setFrame:CGRectMake(0, 0, 320, 240)];
     }
    completion:nil];
    
    self.navigationItem.rightBarButtonItem = closeBarButtonItem;
    isShowingVideo = YES;
}


- (void)hideMiniVideoPlayer
{
    [UIView animateWithDuration:0.3f animations:^
     {
         channelsTableView.frame = CGRectMake(0, 0,
                                              DeviceIsiPad() ? 324 : 320,
                                              DeviceIsiPad() ? self.view.frame.size.height : screenHeight);
         
         [videoView setFrame:CGRectMake(0, -240, 320, 240)];
     }
                     completion:^(BOOL finished)
     {
         
     }];
    
    self.navigationItem.rightBarButtonItem = nil;
    isShowingVideo = NO;
}


- (void)closeButtonTapped
{
    if(DeviceIsiPad())
    {
        [self.detailViewController closeMasterView];
    }
    else
    {
        [self hideMiniVideoPlayer];
        [videoView stopPlayingVideo];
    }
    self.title = @"iTV";
}



// - - - - - - - - - - - -



#pragma mark iTVVideoViewDelegate methods


- (void)videoDidTapDone
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if(UIDeviceOrientationIsLandscape(deviceOrientation))
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [videoView setNewFrame:CGRectMake(0, 0, DeviceIs4Inch() ? 568 : 480,  320)];
    }
    else if(UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [videoView setNewFrame:CGRectMake(0, 0, 320, 240)];
        
        CGRect channelsTableViewFrame = channelsTableView.frame;
        if(isShowingVideo == YES)
        {
            channelsTableViewFrame.origin.y = 240;
        }
        else
        {
            channelsTableViewFrame.origin.y = 0;
        }
        
        channelsTableView.frame = channelsTableViewFrame;
        [videoView hideVideoControls];
    }
}


- (void)videoDidInitialTap
{
    // do nothing
}



// - - - - - - - - - - - -



@end
