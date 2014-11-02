//
//  FirstViewController.h
//  HKNTV
//
//  Created by ZhiYou on 11/2/14.
//  Copyright (c) 2014 ZhiYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *liveCollection;
@property (strong, nonatomic)NSMutableArray *dataMArr;

@end

