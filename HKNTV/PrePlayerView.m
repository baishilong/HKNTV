//
//  PrePlayerView.m
//  HKNTV
//
//  Created by chen wei on 15/2/16.
//  Copyright (c) 2015年 ZhiYou. All rights reserved.
//

#import "PrePlayerView.h"
#import "NTVSize.h"
#import <CoreMedia/CMTextMarkup.h>


@implementation PrePlayerView{
    id playbackObserver;
    
    BOOL viewIsShowing;
}
//static int flag_cc = 1, flag_audio = 1;
//
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


-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.playerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

-(void)initConfigrationWithFrame:(CGRect)frame ContentURL:(NSURL *)contentURL{
    
    [self setFrame:frame];
    
    
    AVAsset *asset = [AVAsset assetWithURL:contentURL];
    self.subtitles = [asset mediaSelectionGroupForMediaCharacteristic:AVMediaCharacteristicLegible];
    self.audioTracks = [asset mediaSelectionGroupForMediaCharacteristic:AVMediaCharacteristicAudible];
    self.filtered = [NSArray arrayWithArray:[AVMediaSelectionGroup mediaSelectionOptionsFromArray:[self.subtitles options] filteredAndSortedAccordingToPreferredLanguages:[NSLocale preferredLanguages]]];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    playerItem.textStyleRules = @[[[AVTextStyleRule alloc] initWithTextMarkupAttributes:
                                   @{(id)kCMTextMarkupAttribute_ItalicStyle : @(YES),
                                     (id)kCMTextMarkupAttribute_OrthogonalLinePositionPercentageRelativeToWritingDirection: @(80)}]];
    self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    self.contentURL = contentURL;
    [self.playerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self.layer addSublayer:self.playerLayer];
    [self bringSubviewToFront:self.CCSelection];
    [self bringSubviewToFront:self.AudioSelection];
    [self bringSubviewToFront:self.playerHudBottom];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];

    
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
    self.playBackTotalTime.text = [self getStringFromCMTime:self.moviePlayer.currentItem.asset.duration];
    
}

-(void)initMediaOptionButtons{
    NSInteger count4Sbtl = [[self.subtitles options]count];
    //resize ccselection frame
    [self.CCSelection setFrame: CGRectMake(self.CC.frame.origin.x,
                                          SCREEN_HEIGHT-30,
                                          MEDIA_OPTION_BUTTON_WIDTH,
                                          MEDIA_OPTION_BUTTON_HEIGHT * count4Sbtl)];
    //update ccselection option button title
    NSMutableArray *sbtlNameHolder = [[NSMutableArray alloc]init];
    
    for (AVMediaSelectionOption *option in [self.subtitles options]) {
        [sbtlNameHolder addObject:option.extendedLanguageTag];
    }
    for (UIButton *button in [self.CCSelection subviews]) {
        if (button.tag < count4Sbtl) {
//            NSString *str = [sbtlNameHolder[button.tag] substringWithRange:NSMakeRange(0, 2)];
            NSString *str = sbtlNameHolder[button.tag];
            [button setTitle:str forState:UIControlStateNormal];
        }
    }

    
    
    
    NSInteger count4Audio = [[self.audioTracks options] count];
    //resize AudioSelection frame
    [self.AudioSelection setFrame:CGRectMake(self.Audio.frame.origin.x,
                                            SCREEN_HEIGHT-30,
                                            MEDIA_OPTION_BUTTON_WIDTH,
                                            MEDIA_OPTION_BUTTON_HEIGHT * count4Audio)];
    //update ccselection option button title
    NSMutableArray *audioNameHolder = [[NSMutableArray alloc]init];
    
    for (AVMediaSelectionOption *option in [self.audioTracks options]) {
        [audioNameHolder addObject:option.extendedLanguageTag];
    }
    for (UIButton *button in [self.AudioSelection subviews]) {
        if (button.tag < count4Audio) {
//            NSString *str = [audioNameHolder[button.tag] substringWithRange:NSMakeRange(0, 2)];
            NSString *str = audioNameHolder[button.tag];
            [button setTitle:str forState:UIControlStateNormal];
        }
    }
}



#pragma mark  - play time refresh
-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

-(void)playerFinishedPlaying
{
    [self.moviePlayer pause];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self.playPauseButton setSelected:NO];
    self.isPlaying = NO;
    if ([self.delegate respondsToSelector:@selector(prePlayerFinishedPlayback:)]) {
        [self.delegate prePlayerFinishedPlayback:self];
    }
}


#pragma mark - screen rotation
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

#pragma mark  - player control
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

-(IBAction)progressBarChanged:(UISlider*)sender
{
    if (self.isPlaying) {
        [self.moviePlayer pause];
    }
    CMTime seekTime = CMTimeMakeWithSeconds(sender.value * (double)self.moviePlayer.currentItem.asset.duration.value/(double)self.moviePlayer.currentItem.asset.duration.timescale, self.moviePlayer.currentTime.timescale);
    [self.moviePlayer seekToTime:seekTime];
}

-(IBAction)proressBarChangeEnded:(UISlider*)sender
{
    if (self.isPlaying) {
        [self.moviePlayer play];
    }
}


-(void)dealloc
{
    [self.moviePlayer removeTimeObserver:playbackObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - closed caption & audio

- (IBAction)touchCloseCaption:(UIButton*)sender {
    
    CGFloat offset;
    NSInteger count =[[self.subtitles options]count];
    
    if (self.CCSelection.frame.origin.y == SCREEN_HEIGHT -30) {
        [self.CCSelection setHidden:NO];
        offset = -MEDIA_OPTION_BUTTON_HEIGHT * count;
    }else{
        
        offset = MEDIA_OPTION_BUTTON_HEIGHT * count;
    }
    [UIView animateWithDuration:0.2f animations:^{
        [self.CCSelection setFrame:CGRectMake(self.CCSelection.frame.origin.x,
                                              self.CCSelection.frame.origin.y+offset,
                                              self.CCSelection.frame.size.width,
                                              self.CCSelection.frame.size.height)];
    } completion:^(BOOL finished) {
        if (self.CCSelection.frame.origin.y == SCREEN_HEIGHT -30) {
            [self.CCSelection setHidden:YES];
        }else{
           
        }
    }];
}

- (IBAction)updateCC:(UIButton*)sender{
    NSString *languageCode = sender.titleLabel.text;
    self.filtered = [NSArray arrayWithArray:[AVMediaSelectionGroup mediaSelectionOptionsFromArray:[self.subtitles options] filteredAndSortedAccordingToPreferredLanguages:[NSArray arrayWithObjects:languageCode, nil]]];
    [self.moviePlayer.currentItem selectMediaOption:[self.filtered objectAtIndex:0] inMediaSelectionGroup:self.subtitles];
    

}
- (IBAction)touchAduioTrack:(UIButton*)sender {
    CGFloat offset;
    NSInteger count =[[self.audioTracks options]count];
    
    if (self.AudioSelection.frame.origin.y == SCREEN_HEIGHT -30) {
        [self.AudioSelection setHidden:NO];
        offset = -MEDIA_OPTION_BUTTON_HEIGHT * count;
    }else{
        
        offset = MEDIA_OPTION_BUTTON_HEIGHT * count;
    }
    [UIView animateWithDuration:0.2f animations:^{
        [self.AudioSelection setFrame:CGRectMake(self.AudioSelection.frame.origin.x,
                                              self.AudioSelection.frame.origin.y+offset,
                                              self.AudioSelection.frame.size.width,
                                              self.AudioSelection.frame.size.height)];
    } completion:^(BOOL finished) {
        if (self.AudioSelection.frame.origin.y == SCREEN_HEIGHT -30) {
            [self.AudioSelection setHidden:YES];
        }else{
            
        }
    }];
}
-(IBAction)updateAudio:(UIButton*)sender{
    NSString *languageCode = sender.titleLabel.text;
    self.filtered = [NSArray arrayWithArray:[AVMediaSelectionGroup mediaSelectionOptionsFromArray:[self.audioTracks options] filteredAndSortedAccordingToPreferredLanguages:[NSArray arrayWithObjects:languageCode, nil]]];
    [self.moviePlayer.currentItem selectMediaOption:[self.filtered objectAtIndex:0] inMediaSelectionGroup:self.audioTracks];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    NSLog(@"Touch Location:%f,%f",
          touchLocation.x,
          touchLocation.y);
    NSLog(@"CCSelection Frame:%f,%f,%f,%f",
          self.CCSelection.frame.origin.x,
          self.CCSelection.frame.origin.y,
          self.CCSelection.frame.size.width,
          self.CCSelection.frame.size.height);
    NSLog(@"CCSelection Bounds:%f,%f,%f,%f",
          self.CCSelection.bounds.origin.x,
          self.CCSelection.bounds.origin.y,
          self.CCSelection.bounds.size.width,
          self.CCSelection.bounds.size.height);
    
    if (!CGRectContainsPoint(self.CCSelection.frame, touchLocation) && self.CCSelection.frame.origin.y != SCREEN_HEIGHT -30 ) {
        [self touchCloseCaption:self.CC];
    }
    if (!CGRectContainsPoint(self.AudioSelection.frame, touchLocation) && self.AudioSelection.frame.origin.y != SCREEN_HEIGHT -30) {
        [self touchAduioTrack:self.Audio];
    }

}






@end
