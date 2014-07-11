//
//  iTVVideoView.m
//  iTV
//
//  Created by Ahmed Farghaly on 7/6/14.
//  Copyright (c) 2014 Ahmed Farghaly. All rights reserved.
//

#import "iTVVideoView.h"
#import "AVFoundation/AVAudioSession.h"
#import "DeviceUtils.h"


@interface iTVVideoView()
{
    float indicatorViewDimension;
    UIActivityIndicatorView *indicatorView;
    MPMovieScalingMode currentScalingMode;
    
    float videoPlaybackIconDimension;
    UIImageView *videoPlaybackIconImageView;
    
    BOOL videoHasPlayed;
    UIImageView *tvImageView;
}

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@end



// - - - - - - - - - - - -



@implementation iTVVideoView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        videoHasPlayed = NO;
        
        // enable playback while device is locked
        NSError *setCategoryError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        
        currentScalingMode = MPMovieScalingModeAspectFit;
        
        // create movie player
        _moviePlayer = [[MPMoviePlayerController alloc] init];
        [_moviePlayer prepareToPlay];
        [self addSubview:_moviePlayer.view];
        [_moviePlayer.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_moviePlayer setScalingMode:currentScalingMode];
        _moviePlayer.shouldAutoplay = YES;
        _moviePlayer.allowsAirPlay = YES;
        _moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        
        // movie player notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StreamStateChanged) name:MPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doneButtonClicked)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:nil];
        
        // add movie player gestures
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoDoubleTapped)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        [_moviePlayer.view addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTapped)];
        singleTapRecognizer.numberOfTapsRequired = 1;
        singleTapRecognizer.delegate = self;
        [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [_moviePlayer.view addGestureRecognizer:singleTapRecognizer];
        
        // create indicator view
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorViewDimension = DeviceIsiPad() ? 60 : 30;
        indicatorView.frame = CGRectMake((frame.size.width - indicatorViewDimension) / 2, (frame.size.height - indicatorViewDimension) / 2, indicatorViewDimension, indicatorViewDimension);
        [self addSubview:indicatorView];
        indicatorView.hidden = YES;
        
        // video playback icon image view
        videoPlaybackIconDimension = DeviceIsiPad() ? 150 : 70;
        videoPlaybackIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - videoPlaybackIconDimension) / 2, (frame.size.height - videoPlaybackIconDimension) / 2, videoPlaybackIconDimension, videoPlaybackIconDimension)];
        [self addSubview:videoPlaybackIconImageView];
        videoPlaybackIconImageView.alpha = 0;
        
        // TV image
        tvImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 150) / 2, (frame.size.height - 150) / 2, 150, 150)];
        tvImageView.image = [UIImage imageNamed:@"tv-icon"];
        [self addSubview:tvImageView];
    }
    
    return self;
}



// - - - - - - - - - - - -



#pragma mark - video playback methods


- (void)StreamStateChanged
{
    switch(_moviePlayer.loadState)
    {
        case MPMovieLoadStateUnknown:
        case MPMovieLoadStateStalled:
            indicatorView.hidden = NO;
            
            break;
            
        default:
            indicatorView.hidden = YES;
            break;
    }
}


- (void)playStream:(NSString *)streamURL_
{
    NSURL *contentURL = [NSURL URLWithString:streamURL_];
    self.moviePlayer.contentURL = contentURL;
    [self.moviePlayer prepareToPlay];
    
    indicatorView.hidden = NO;
    [indicatorView startAnimating];
    
    videoHasPlayed = YES;
    tvImageView.hidden = YES;
}


- (void)doneButtonClicked
{
    [_moviePlayer play];
    if(_delegate)
    {
        [_delegate videoDidTapDone];
    }
    indicatorView.hidden = YES;
}



// - - - - - - - - - - - -



#pragma mark - instance methods


- (void)setNewFrame:(CGRect)newFrame_
{
    self.frame = newFrame_;
    _moviePlayer.view.frame = newFrame_;
    indicatorView.frame = CGRectMake((newFrame_.size.width - indicatorViewDimension) / 2, (newFrame_.size.height - indicatorViewDimension) / 2, indicatorViewDimension, indicatorViewDimension);
    videoPlaybackIconImageView.frame = CGRectMake((newFrame_.size.width - videoPlaybackIconDimension) / 2, (newFrame_.size.height - videoPlaybackIconDimension) / 2, videoPlaybackIconDimension, videoPlaybackIconDimension);
    tvImageView.frame = CGRectMake((newFrame_.size.width - 150) / 2, (newFrame_.size.height - 250) / 2, 150, 150);
}


- (void)stopPlayingVideo
{
    [_moviePlayer stop];
}


- (void)showVideoControls
{
    _moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
}


- (void)hideVideoControls
{
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
}


- (void)setVideoScalingMode:(MPMovieScalingMode)newScalingMode_
{
    [_moviePlayer setScalingMode:newScalingMode_];
}



// - - - - - - - - - - - -



#pragma mark - UIGestureRecognizer handling methods


- (void)videoTapped
{
    if(videoHasPlayed == NO)
    {
        if(_delegate)
        {
            [_delegate videoDidInitialTap];
        }
    }
    
    if(_moviePlayer.playbackState == MPMoviePlaybackStatePaused)
    {
        [_moviePlayer play];
        videoPlaybackIconImageView.image = [UIImage imageNamed:@"videoPlayingIcon"];
        videoPlaybackIconImageView.alpha = 1;
    }
    else if(_moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        [_moviePlayer pause];
        videoPlaybackIconImageView.image = [UIImage imageNamed:@"videoPausedIcon"];
        videoPlaybackIconImageView.alpha = 1;
    }
    
    [UIView animateWithDuration:0.7f animations:^{
        videoPlaybackIconImageView.alpha = 0;
    }];
}


- (void)videoDoubleTapped
{
    if(currentScalingMode == MPMovieScalingModeAspectFit)
    {
        currentScalingMode = MPMovieScalingModeAspectFill;
    }
    else
    {
        currentScalingMode = MPMovieScalingModeAspectFit;
    }
    
    _moviePlayer.scalingMode = currentScalingMode;
}



// - - - - - - - - - - - -



#pragma mark - UIGestureRecognizerDelegate methods


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



// - - - - - - - - - - - -



@end
