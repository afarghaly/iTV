//
//  iTVVideoView.h
//  iTV
//
//  Created by Ahmed Farghaly on 7/6/14.
//  Copyright (c) 2014 Ahmed Farghaly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol iTVVideoViewDelegate

- (void)videoDidTapDone;

@end


@interface iTVVideoView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id <iTVVideoViewDelegate> delegate;

- (void)playStream:(NSString *)streamURL_;
- (void)setNewFrame:(CGRect)newFrame_;
- (void)stopPlayingVideo;
- (void)showVideoControls;
- (void)hideVideoControls;
- (void)setVideoScalingMode:(MPMovieScalingMode)newScalingMode_;

@end
