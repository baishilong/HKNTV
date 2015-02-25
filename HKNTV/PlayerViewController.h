//
//  PlayerViewController.h
//  HKNTV
//
//  Created by Jude on 2015-01-07.
//  Copyright (c) 2015 HKNTV. All rights reserved.
//
//

#import <UIKit/UIKit.h>
//#import "NTVVideoPlayerView.h"
#import "PrePlayerView.h"

@interface PlayerViewController : UIViewController <prePlayerViewDelegate>

@property (nonatomic, assign) NSString *prog_desc;
@property (weak, nonatomic) IBOutlet UIButton *tab1;
@property (weak, nonatomic) IBOutlet UIButton *tab2;
@property (weak, nonatomic) IBOutlet UIButton *tab3;

@property (strong, nonatomic) IBOutlet UIView *tab_detail_holder;
@property (strong, nonatomic) IBOutlet UITextView *tab1_detailV;


@end
