//
//  MyAVPlayerViewController.m
//  HKNTV
//
//  Created by ZhiYou on 11/3/14.
//  Copyright (c) 2014 ZhiYou. All rights reserved by HKNTV.
//

#import "MyAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation MyAVPlayerViewController

#define STREAM_SVR_IP @"192.168.1.106"
//#define STREAM_SVR_IP @"172.16.106.125"

- (void) setupURLArray{
    self.urlArray = [NSMutableArray array];
    
    [self.urlArray addObject:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    [self.urlArray addObject:@"http://219.232.160.141:5080/hls/c64024e7cd451ac19613345704f985fa.m3u8"];
    [self.urlArray addObject:[NSMutableString stringWithFormat:@"http://%@/speed/speed.m3u8", STREAM_SVR_IP]];
    [self.urlArray addObject:[NSMutableString stringWithFormat:@"http://%@/duck/duck.m3u8", STREAM_SVR_IP]];
    [self.urlArray addObject:[NSMutableString stringWithFormat:@"http://%@/duck/duck.m3u8", STREAM_SVR_IP]];
    
    [self.urlArray addObject:[NSMutableString stringWithFormat:@"http://%@/bhaj/cell.m3u8", STREAM_SVR_IP]];

}

- (NSString*)getURLString:(NSInteger)index{
    
    if(index < self.urlArray.count){
        return (NSString *)self.urlArray[index];
    }else{
        return (NSString*)self.urlArray[self.urlArray.count -1];
    }
}

- (void)viewDidLoad{
    [self setupURLArray];
    NSLog(@"MyAVPlayerViewController view loaded with index  %ld", self.prog_id);
    NSURL *url = [NSURL URLWithString:[self getURLString:self.prog_id]];
    NSLog(@"%@", url);
    [self setPlayer: [AVPlayer playerWithURL:url]];
    [self setUpPlayerObwithURL:url];
    [self setVideoGravity:@"AVLayerVideoGravityResizeAspect"];
    [super viewDidLoad];
}

/*
 - (id)addPeriodicTimeObserverForInterval:(CMTime)interval
 queue:(dispatch_queue_t)queue
 usingBlock:(void (^)(CMTime time)){NSLog(@"%lld \n", self.player.currentTime.value);};
 */

//simplely list the product
-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender{
    NSLog(@"are you intrested in this product?");
    int x = 250, y=20;
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft||
       self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        x = 550;
    }
    UIImageView *product = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 100, 150)];
    
    product.backgroundColor = [UIColor blueColor];
    product.alpha = 0.5;
    product.image = [UIImage imageNamed:@"bear.png"];
    [self.view addSubview:product];
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 99)
        {
            [subView removeFromSuperview];
        }
    }
}

- (void) setUpPlayerObwithURL:(NSURL *) url{
    Float64 durationSeconds = CMTimeGetSeconds([[[AVURLAsset alloc] initWithURL:url options:nil] duration]);
    NSLog(@"duration seconds %f", durationSeconds);
    CMTime first = CMTimeMakeWithSeconds(16, 1);
    CMTime second = CMTimeMakeWithSeconds(20, 1);
    CMTime third = CMTimeMakeWithSeconds(40, 1);
    CMTime forth = CMTimeMakeWithSeconds(53, 1);
//    CMTime fifth = CMTimeMakeWithSeconds(16, 1);
//    CMTime sixth = CMTimeMakeWithSeconds(200, 1);
    NSArray *times = @[[NSValue valueWithCMTime:first],
                       [NSValue valueWithCMTime:second],
                       [NSValue valueWithCMTime:third],
                       [NSValue valueWithCMTime:forth],
//                       [NSValue valueWithCMTime:fifth],
//                       [NSValue valueWithCMTime:sixth],
                       ];
    __weak typeof(self) weakSelf = self;
    self.playerOb = [self.player addBoundaryTimeObserverForTimes:times queue:NULL usingBlock:^{
        NSString *timeDescription = (NSString *)
        CFBridgingRelease(CMTimeCopyDescription(NULL, [weakSelf.player currentTime]));
        NSLog(@"Passed a boudary at %@", timeDescription);
        UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 100, 20, 20)];
        picView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf
                                                      action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        singleFingerOne.delegate = weakSelf;
        [picView addGestureRecognizer:singleFingerOne];
        //picView.backgroundColor = [UIColor redColor];
        picView.image = [UIImage imageNamed:@"redmark.png"];
        picView.tag = 99;
        Boolean operated = false;
        
        for (UIView *subView in weakSelf.view.subviews)
        {
            if (subView.tag == 99)
            {
                [subView removeFromSuperview];
                operated = true;
            }
        }
        if(!operated){
            [weakSelf.view addSubview:picView];
        }
    }];
    
    
    
}

@end
