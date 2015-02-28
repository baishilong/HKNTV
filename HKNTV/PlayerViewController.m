//
//  PlayerViewController.m
//  HKNTV
//
//  Created by Jude on 2015-01-07.
//  Copyright (c) 2015 HKNTV. All rights reserved.
//
//

#import "PlayerViewController.h"
//#import "NTVVideoPlayerView.h"
#import "NTVSize.h"
#import "PrePlayerView.h"
@interface PlayerViewController ()

//@property (strong, nonatomic) NTVVideoPlayerView* player;
@property (assign, nonatomic) NSInteger tab_detail_index;
@property (assign, nonatomic) UIDeviceOrientation previous_orientation;
@property (strong, nonatomic) PrePlayerView *pre_player;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pre_player = [[[NSBundle mainBundle]loadNibNamed:@"PrePlayerView" owner:self options:nil]lastObject];
    [self.pre_player setAutoresizingMask:UIViewAutoresizingNone];
    [self.pre_player initConfigrationWithFrame:CGRectMake(0, 20, SCREEN_WIDTH , SCREEN_HEIGHT/3) ContentURL:[NSURL URLWithString:@"http://192.168.1.160/vod/pva/bhmaaa/cell.m3u8"]];
//    [self.pre_player initConfigrationWithFrame:CGRectMake(0, 20, SCREEN_WIDTH , SCREEN_HEIGHT/3) ContentURL:[NSURL URLWithString:@"http://54.187.162.118/tos/tos.m3u8"]];
    [self.pre_player play];
    [self.pre_player setDelegate:self];
    [self.view addSubview:self.pre_player];
    
    self.tab1_detailV.text = self.prog_desc;
    self.tab_detail_index = 0;
    
    self.tab_detail_holder = [[UIView alloc]initWithFrame:CGRectMake(0, 294, 1200, 447)];
    
    self.tab1_detailV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 337.5, 447)];
    self.tab1_detailV.text = self.prog_desc;
    self.tab1_detailV.userInteractionEnabled = NO;
    
    UIView *tab2_detailV = [[UIView alloc]initWithFrame:CGRectMake(400, 0, 400, 447)];
    tab2_detailV.backgroundColor = [UIColor yellowColor];
    UILabel *tab2_hint = [[UILabel alloc]initWithFrame:CGRectMake(150, 150, 100, 30)];
    tab2_hint.text = @"评论－详情";
    [tab2_detailV addSubview:tab2_hint];
    
    UIView *tab3_detailV = [[UIView alloc]initWithFrame:CGRectMake(800, 0, 400, 447)];
    tab3_detailV.backgroundColor = [UIColor redColor];
    UILabel *tab3_hint = [[UILabel alloc]initWithFrame:CGRectMake(150, 150, 100, 30)];
    tab3_hint.text = @"推荐－详情";
    [tab3_detailV addSubview:tab3_hint];
    
    
    [self.tab_detail_holder addSubview:self.tab1_detailV];
    [self.tab_detail_holder addSubview:tab2_detailV];
    [self.tab_detail_holder addSubview:tab3_detailV];
    
    [self.view addSubview:self.tab_detail_holder];
    
    
    
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.tab1 setFrame:CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH/3, 30)];
    [self.tab1 setFrame:CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/3, SCREEN_WIDTH/3, 30)];
    [self.tab1 setFrame:CGRectMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/3, SCREEN_WIDTH/3, 30)];
    [self.view.layer setNeedsLayout];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
            if (UIDeviceOrientationIsLandscape(self.previous_orientation)||self.pre_player.isFullScreenMode) {
                self.pre_player.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }else{
                self.pre_player.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            }
            self.tab_detail_holder.hidden = YES;
            self.pre_player.isFullScreenMode = YES;
            [self.pre_player.zoomButton setSelected:YES];

        } else {
            self.pre_player.frame = CGRectMake(0,20, SCREEN_HEIGHT,SCREEN_WIDTH/3);
            self.pre_player.isFullScreenMode = NO;
            [self.pre_player.zoomButton setSelected:NO];
            self.tab_detail_holder.hidden = NO;
            [self.tab_detail_holder setFrame:CGRectMake(0, 304, 1200, 447)];
            
        
        }
    } completion:^(BOOL finished) {
        NSLog(@"%f,%f,%f,%f",self.pre_player.frame.origin.x,self.pre_player.frame.origin.y,self.pre_player.frame.size.width,self.pre_player.frame.size.height);
    }];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.pre_player.CCSelection setHidden:YES];
    [self.pre_player.AudioSelection setHidden:YES];
    
    [self.pre_player.CCSelection setFrame:CGRectMake(self.pre_player.CC.frame.origin.x,
                                                     SCREEN_HEIGHT-30,
                                                     MEDIA_OPTION_BUTTON_WIDTH,
                                                     MEDIA_OPTION_BUTTON_HEIGHT *10)];
    
    [self.pre_player.AudioSelection setFrame:CGRectMake(self.pre_player.Audio.frame.origin.x,
                                                       SCREEN_HEIGHT-30,
                                                        MEDIA_OPTION_BUTTON_WIDTH,
                                                        MEDIA_OPTION_BUTTON_HEIGHT *10)];
    [self.pre_player initMediaOptionButtons];

}

-(IBAction)didSwitchTab:(UIButton*)sender{
    
    switch (self.tab_detail_index) {
        case 0:{
            
            switch (sender.tag) {
                case 0:
                    
                    break;
                    
                case 1:{
                    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        CGRect current = self.tab_detail_holder.frame;
                        [self.tab_detail_holder setFrame:CGRectMake(current.origin.x-400,
                                                                    current.origin.y,
                                                                    current.size.width,
                                                                    current.size.height)];
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                    break;
                }
                case 2:
                {
                    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        CGRect current = self.tab_detail_holder.frame;
                        [self.tab_detail_holder setFrame:CGRectMake(current.origin.x-800,
                                                                    current.origin.y,
                                                                    current.size.width,
                                                                    current.size.height)];
                    } completion:^(BOOL finished) {
                     
                    }];
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
            
        }
        case 1:{
            
            switch (sender.tag) {
                case 0:
                {
                    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        CGRect current = self.tab_detail_holder.frame;
                        [self.tab_detail_holder setFrame:CGRectMake(current.origin.x+400,
                                                                    current.origin.y,
                                                                    current.size.width,
                                                                    current.size.height)];
                    } completion:^(BOOL finished) {

                    }];
                    
                    break;
                }
                case 1:
                    
                    break;
                    
                case 2:{
                    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        CGRect current = self.tab_detail_holder.frame;
                        [self.tab_detail_holder setFrame:CGRectMake(current.origin.x-400,
                                                                    current.origin.y,
                                                                    current.size.width,
                                                                    current.size.height)];
                    } completion:^(BOOL finished) {
                       
                    }];
                    
                    break;
                }
                default:
                    break;
            }
            break;
            
        }
        case 2:{
            
            switch (sender.tag) {
                case 0:{
                    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        CGRect current = self.tab_detail_holder.frame;
                        [self.tab_detail_holder setFrame:CGRectMake(current.origin.x+800,
                                                                    current.origin.y,
                                                                    current.size.width,
                                                                    current.size.height)];
                    } completion:^(BOOL finished) {
                      
                    }];
                    
                    break;
                }
                    
                case 1:{
                    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        CGRect current = self.tab_detail_holder.frame;
                        [self.tab_detail_holder setFrame:CGRectMake(current.origin.x+400,
                                                                    current.origin.y,
                                                                    current.size.width,
                                                                    current.size.height)];
                    } completion:^(BOOL finished) {
                      
                    }];
                    
                    break;
                }
                case 2:
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        }
            
        default:
            break;
    }
    self.tab_detail_index = sender.tag;
    
}

-(void)viewDidLayoutSubviews
{
    self.previous_orientation = [[UIDevice currentDevice] orientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark preplayerViewDelegate

-(void)prePlayerViewZoomButtonClicked:(PrePlayerView *)view{
    if (self.pre_player.isFullScreenMode) {
        [self performOrientationChange:UIInterfaceOrientationPortrait];
        self.pre_player.isFullScreenMode = NO;
        NSLog(@"playerViewZoomButtonClicked: isFullScreenMode");
    } else {
        [self performOrientationChange:UIInterfaceOrientationLandscapeRight];
        self.pre_player.isFullScreenMode = YES;
        NSLog(@"playerViewZoomButtonClicked");
    }
}

-(void)performOrientationChange:(UIInterfaceOrientation)toInterfaceOrientation{

    NSNumber *value = [NSNumber numberWithInt:toInterfaceOrientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
}

//-(void)playerFinishedPlayback:(NTVVideoPlayerView*)view
//{
//    NSLog(@"playerFinishedPlayback");
//}

#pragma mark -Orientation

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    if (self.player.isFullScreenMode) {
//        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//    } else {
//        return NO;
//    }
//}
//
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
@end
