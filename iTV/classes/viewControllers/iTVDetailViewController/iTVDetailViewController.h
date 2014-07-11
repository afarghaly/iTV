//
//  iTVDetailViewController.h
//  iTV
//
//  Created by Ahmed Farghaly on 7/4/14.
//  Copyright (c) 2014 Ahmed Farghaly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iTVVideoView.h"

@interface iTVDetailViewController : UIViewController <UISplitViewControllerDelegate, iTVVideoViewDelegate>

- (void)closeMasterView;
- (void)playChannel:(NSDictionary *)channelData_;

@end
