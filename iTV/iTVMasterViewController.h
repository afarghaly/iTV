//
//  iTVMasterViewController.h
//  iTV
//
//  Created by Ahmed Farghaly on 7/4/14.
//  Copyright (c) 2014 Ahmed Farghaly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iTVVideoView.h"

@class iTVDetailViewController;

@interface iTVMasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, iTVVideoViewDelegate>

@property (strong, nonatomic) iTVDetailViewController *detailViewController;

@end
