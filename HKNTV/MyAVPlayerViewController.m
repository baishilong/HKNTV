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

- (void) setupURLArray{
    self.urlArray = [NSMutableArray array];
    
    [self.urlArray addObject:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    [self.urlArray addObject:@"http://10.10.10.112/speed/speed.m3u8"];
    
    
    [self.urlArray addObject:@"http://10.10.10.112/duck/duck.m3u8"];

    
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
}

@end
