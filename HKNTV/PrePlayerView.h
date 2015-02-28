//
//  PrePlayerView.h
//  HKNTV
//
//  Created by chen wei on 15/2/16.
//  Copyright (c) 2015年 ZhiYou. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class PrePlayerView;

@protocol prePlayerViewDelegate <NSObject>
@optional
-(void)prePlayerViewZoomButtonClicked:(PrePlayerView*)view;
-(void)prePlayerFinishedPlayback:(PrePlayerView*)view;

@end

@interface PrePlayerView : UIView <UIPopoverControllerDelegate>

@property (weak, nonatomic) id <prePlayerViewDelegate> delegate;

@property (assign, nonatomic) BOOL isFullScreenMode;
@property (retain, nonatomic) NSURL *contentURL;
@property (retain, nonatomic) AVPlayer *moviePlayer;
@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic)AVPlayerLayer *playerLayer;


@property (retain, nonatomic)IBOutlet UIButton *playPauseButton;
@property (retain, nonatomic)IBOutlet UIButton *volumeButton;
@property (retain, nonatomic)IBOutlet UIButton *zoomButton;
//@property (retain, nonatomic) MPVolumeView *airplayButton;

@property (retain, nonatomic) IBOutlet UISlider *progressBar;
@property (retain, nonatomic) UISlider *volumeBar;

@property (retain, nonatomic) IBOutlet UILabel *playBackTime;
@property (retain, nonatomic) IBOutlet UILabel *playBackTotalTime;

@property (retain,nonatomic) UIView *playerHudCenter;
@property (strong,nonatomic) IBOutlet UIView *playerHudBottom;

@property(retain, nonatomic) NSArray *filtered;
@property(retain, nonatomic) AVMediaSelectionGroup * subtitles;
@property(retain, nonatomic) AVMediaSelectionGroup * audioTracks;

@property(retain, nonatomic) IBOutlet UIView *CCSelection;
@property(retain, nonatomic) IBOutlet UIView *AudioSelection;
@property(retain, nonatomic)IBOutlet UIButton *CC;
@property(retain, nonatomic)IBOutlet UIButton *Audio;




-(void)initConfigrationWithFrame:(CGRect)frame ContentURL:(NSURL*)contentURL;
-(void)initMediaOptionButtons;

//- (id)initWithFrame:(CGRect)frame contentURL:(NSURL*)contentURL;

-(void)play;
-(void)pause;



@end
