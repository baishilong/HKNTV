//
//  MyAVPlayerViewController.h
//  HKNTV
//
//  Created by ZhiYou on 11/3/14.
//  Copyright (c) 2014 ZhiYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface MyAVPlayerViewController : AVPlayerViewController

@property(nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) NSInteger prog_id;

@end
