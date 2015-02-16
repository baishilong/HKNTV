//
//  PlayerViewController.m
//  HKNTV
//
//  Created by Jude on 2015-01-07.
//  Copyright (c) 2015 HKNTV. All rights reserved.
//
//

#import "PlayerViewController.h"
#import "NTVVideoPlayerView.h"
#import "NTVSize.h"
@interface PlayerViewController ()

@property (strong, nonatomic) NTVVideoPlayerView* player;
@property (assign, nonatomic) NSInteger tab_detail_index;
@property (assign, nonatomic) UIDeviceOrientation previous_orientation;
@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 20, 320, 180) contentURL:[NSURL URLWithString:@"http://219.232.160.141:5080/hls/c64024e7cd451ac19613345704f985fa.m3u8"]];
    //    self.player = [[NTVVideoPlayerView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH , SCREEN_HEIGHT/3) contentURL:[NSURL URLWithString:@"http://192.168.1.160/samples/bhaj/hkntv,How.to.Train.Your.Dragon.2.aj_400K.m3u8"]];
    
    self.player = [[NTVVideoPlayerView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH , SCREEN_HEIGHT/3) contentURL:[NSURL URLWithString:@"http://219.232.160.141:5080/hls/c64024e7cd451ac19613345704f985fa.m3u8"]];
    
    [self.view addSubview:self.player];
    self.player.tintColor = [UIColor redColor];
    [self.player play];
    [self.player setDelegate:self];
    
    //    self.tab1_detailV.text = self.prog_desc;
    self.tab_detail_index = 0;
    
    self.tab_detail_holder = [[UIView alloc]initWithFrame:CGRectMake(0, 294, 1200, 447)];
    
    self.tab1_detailV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 400, 447)];
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

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//    [self.tab1 setFrame:CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH/3, 30)];
//    [self.tab1 setFrame:CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/3, SCREEN_WIDTH/3, 30)];
//    [self.tab1 setFrame:CGRectMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/3, SCREEN_WIDTH/3, 30)];
//    [self.view.layer setNeedsLayout];
//}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
            if (UIDeviceOrientationIsLandscape(self.previous_orientation)||self.player.isFullScreenMode) {
                self.player.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                
            }else{
                self.player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
            }
            self.tab_detail_holder.hidden = YES;
            self.player.isFullScreenMode = YES;

        } else {
            self.player.frame = CGRectMake(0, 20, SCREEN_HEIGHT, SCREEN_WIDTH/3);
            self.tab_detail_holder.hidden = NO;
            [self.tab_detail_holder setFrame:CGRectMake(0, 304, 1200, 447)];
            self.player.isFullScreenMode = NO;
            //            self.tab_detail_index = 0;
        }
    } completion:^(BOOL finished) {
        
    }];
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
                        //                            self.tab_detail_index = 1;
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
                        //                            self.tab_detail_index = 2;
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
                        //                            self.tab_detail_index = 0;
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
                        //                            self.tab_detail_index = 2;
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
                        //                            self.tab_detail_index = 0   ;
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
                        //                            self.tab_detail_index = 1;
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
    //    NSLog(@"layout subviews called");
//    int width = self.view.frame.size.width;
//    int height = self.view.frame.size.height;
    
    //    NSLog(@"%d x %d",width, height);
    
    self.previous_orientation = [[UIDevice currentDevice] orientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark playerViewDelegate

-(void)playerViewZoomButtonClicked:(NTVVideoPlayerView*)view
{
    
    if (self.player.isFullScreenMode) {
        [self performOrientationChange:UIInterfaceOrientationPortrait];
        self.player.isFullScreenMode = NO;
        NSLog(@"playerViewZoomButtonClicked: isFullScreenMode");
    } else {
        [self performOrientationChange:UIInterfaceOrientationLandscapeRight];
        self.player.isFullScreenMode = YES;
        NSLog(@"playerViewZoomButtonClicked");
    }
}

-(void)performOrientationChange:(UIInterfaceOrientation)toInterfaceOrientation{
    
//    [UIView animateWithDuration:0.5 animations:^{
//        if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
//            self.player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//            self.tab_detail_holder.hidden = YES;
//            
//        } else {
//            self.player.frame = CGRectMake(0, 20, SCREEN_HEIGHT, SCREEN_WIDTH/3);
//            self.tab_detail_holder.hidden = NO;
//            [self.tab_detail_holder setFrame:CGRectMake(0, 304, 1200, 447)];
//            //            self.tab_detail_index = 0;
//        }
//    } completion:^(BOOL finished) {
//        
//    }];
    NSNumber *value = [NSNumber numberWithInt:toInterfaceOrientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
}

-(void)playerFinishedPlayback:(NTVVideoPlayerView*)view
{
    NSLog(@"playerFinishedPlayback");
}

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
