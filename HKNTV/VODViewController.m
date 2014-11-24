//
//  SecondViewController.m
//  HKNTV
//
//  Created by ZhiYou on 11/2/14.
//  Copyright (c) 2014 ZhiYou. All rights reserved.
//

#import "VODViewController.h"

@interface VODViewController ()

@end



@implementation VODViewController

-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender{
    NSLog(@"tapped in image");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _img.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    singleFingerOne.delegate = self;
    
    [self.img addGestureRecognizer:singleFingerOne];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
