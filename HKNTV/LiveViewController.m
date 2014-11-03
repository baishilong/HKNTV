//
//  FirstViewController.m
//  HKNTV
//
//  Created by ZhiYou on 11/2/14.
//  Copyright (c) 2014 ZhiYou. All rights reserved.
//  https://github.com/judeyouzhi/HKNTV

#import "LiveViewController.h"
#import "LiveCollectionViewCell.h"
#import "MyAVPlayerViewController.h"

@interface LiveViewController ()

@end

@implementation LiveViewController

#define MAX_ITEMS 29

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollection];
}

-(void)setUpCollection{
    self.dataMArr = [NSMutableArray array];
    for(NSInteger index = 0; index<MAX_ITEMS; index++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)index+1]];
        NSString *title = [NSString stringWithFormat:@"{0,%ld}",(long)index+1];
        NSDictionary *dic = @{@"image": image, @"title":title};
        [self.dataMArr addObject:dic];
    }
    self.liveCollection.delegate = self;
    self.liveCollection.dataSource = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Source
 

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataMArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectionCellID = @"live_cell";
    LiveCollectionViewCell *cell = (LiveCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    NSDictionary *dic    = self.dataMArr[indexPath.row];
    UIImage *image       = dic[@"image"];
    NSString *title      = dic[@"title"];
    
    cell.img.image = image;
    cell.title.text = title;
    
    return cell;
};


#pragma mark - Collection daleagte


- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected %ld in live collection view", indexPath.row);
    self.selected_id = indexPath.row;
    return YES;
}

#pragma mark - Others

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pushLivePlayer"]){ MyAVPlayerViewController *playerController = segue.destinationViewController;
        [playerController setProg_id:self.selected_id];
    } }

@end
