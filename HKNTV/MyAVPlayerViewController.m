//
//  MyAVPlayerViewController.m
//  HKNTV
//
//  Created by ZhiYou on 11/3/14.
//  Copyright (c) 2014 ZhiYou. All rights reserved.
//

#import "MyAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation MyAVPlayerViewController


- (void)viewDidLoad{
    NSLog(@" in MyAVPlayerViewController %ld", self.prog_id);
    NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    [self setPlayer: [AVPlayer playerWithURL:url]];
}

@end
