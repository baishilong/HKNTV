//
//  PrePlayerView.m
//  HKNTV
//
//  Created by chen wei on 15/2/16.
//  Copyright (c) 2015年 ZhiYou. All rights reserved.
//

#import "PrePlayerView.h"
#import "NTVSize.h"

@implementation PrePlayerView{
    id playbackObserver;
    
    BOOL viewIsShowing;
}


//- (id)initWithFrame:(CGRect)frame contentURL:(NSURL*)contentURL
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:contentURL];
//        self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
//        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
//        [_playerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        [self.moviePlayer seekToTime:kCMTimeZero];
//        [self.layer addSublayer:_playerLayer];
//        self.contentURL = contentURL;
//        
//    }
//    return self;
//}


-(void)initConfigrationWithFrame:(CGRect)frame ContentURL:(NSURL *)contentURL{
    
    [self setFrame:frame];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:contentURL];
    self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    [self.playerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self.layer addSublayer:self.playerLayer];
    self.contentURL = contentURL;
    
    [self bringSubviewToFront:self.playerHudBottom];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    
    //refresh played time
    CMTime interval = CMTimeMake(33, 1000);
    __weak __typeof(self) weakself = self;
    playbackObserver = [self.moviePlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
        CMTime endTime = CMTimeConvertScale (weakself.moviePlayer.currentItem.asset.duration, weakself.moviePlayer.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            double normalizedTime = (double) weakself.moviePlayer.currentTime.value / (double) endTime.value;
            weakself.progressBar.value = normalizedTime;
        }
        weakself.playBackTime.text = [weakself getStringFromCMTime:weakself.moviePlayer.currentTime];
    }];

    
}
-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.playerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//    [self.playerLayer setFrame:frame];
}

#pragma  - play time refresh
-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}


#pragma - screen rotation
-(IBAction)zoomButtonPressed:(UIButton*)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
    }];
    [self.delegate prePlayerViewZoomButtonClicked:self];
}

-(void)setIsFullScreenMode:(BOOL)isFullScreenMode
{
    _isFullScreenMode = isFullScreenMode;
    //    if (isFullScreenMode) {
    //        self.backgroundColor = [UIColor blackColor];
    //    } else {
    //        self.backgroundColor = [UIColor clearColor];
    //    }
    self.backgroundColor = [UIColor blackColor];
}

#pragma  - player control
-(IBAction)playButtonAction:(UIButton*)sender
{
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

-(void)play
{
    [self.moviePlayer play];
    self.isPlaying = YES;
    [self.playPauseButton setSelected:YES];
}

-(void)pause
{
    [self.moviePlayer pause];
    self.isPlaying = NO;
    [self.playPauseButton setSelected:NO];
}

-(void)dealloc
{
    [self.moviePlayer removeTimeObserver:playbackObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}






@end
