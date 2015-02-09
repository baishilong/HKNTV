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
#import "NTVColor.h"

@interface LiveViewController ()

@property (nonatomic,strong) NSMutableArray *names;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation LiveViewController

#define MAX_ITEMS 29

- (void) setupNameArray{
    self.names = [NSMutableArray array];
    
    [self.names addObject:@"Bedknobs and Broomsticks"];
    [self.names addObject:@"Clear and Present Danger"];
    [self.names addObject:@"A Cinderella Story"];
    [self.names addObject:@"Ernest Goes to Camp"];
    [self.names addObject:@"The Final Destination"];
    [self.names addObject:@"Five Easy Pieces"];
    [self.names addObject:@"Gangs of New York"];
    [self.names addObject:@"Good Will Hunting"];
    [self.names addObject:@"Mad Max 2: The Road Warrior"];
    [self.names addObject:@"Bedknobs and Broomsticks"];
    [self.names addObject:@"Clear and Present Danger"];
    [self.names addObject:@"A Cinderella Story"];
    [self.names addObject:@"Ernest Goes to Camp"];
    [self.names addObject:@"The Final Destination"];
    [self.names addObject:@"Five Easy Pieces"];
    [self.names addObject:@"Gangs of New York"];
    [self.names addObject:@"Good Will Hunting"];
    [self.names addObject:@"Mad Max 2: The Road Warrior"];
    [self.names addObject:@"Bedknobs and Broomsticks"];
    [self.names addObject:@"Clear and Present Danger"];
    [self.names addObject:@"A Cinderella Story"];
    [self.names addObject:@"Ernest Goes to Camp"];
    [self.names addObject:@"The Final Destination"];
    [self.names addObject:@"Five Easy Pieces"];
    [self.names addObject:@"Gangs of New York"];
    [self.names addObject:@"Good Will Hunting"];
    [self.names addObject:@"Mad Max 2: The Road Warrior"];
    [self.names addObject:@"Gangs of New York"];
    [self.names addObject:@"Good Will Hunting"];
    [self.names addObject:@"Mad Max 2: The Road Warrior"];
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad live");
    [super viewDidLoad];
    [self setupNameArray];
    [self setUpCollection];
    /* Create the refresh control */
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                            action:@selector(handleRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    self.liveCollection.alwaysBounceVertical = YES;
    [self.liveCollection addSubview:refreshControl];
}

-(void)setUpCollection{
    self.dataMArr = [NSMutableArray array];
    for(NSInteger index = 0; index<MAX_ITEMS; index++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)index+1]];
        NSString *title = [NSString stringWithFormat:@"%@", self.names[index]];
        
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
//        [dic setObject:image forKey:@"image"];
//        [dic setObject:title forKey:@"title"];
//        [dic setObject:@false forKey:@"isLive"];
        NSMutableDictionary * dic = [NSMutableDictionary
                                       dictionaryWithObjects:@[image, title, @false]
                                       forKeys:@[@"image",@"title",@"isLive"]];
        
        if (index == 2 || index == 3) {
            dic[@"isLive"] = @true;
        }
        [self.dataMArr addObject:dic];
    }
    self.liveCollection.delegate = self;
    self.liveCollection.dataSource = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleRefresh:(id)paramSender{
    
    /* Put a bit of delay between when the refresh control is released
     and when we actually do the refreshing to make the UI look a bit
     smoother than just doing the update without the animation */
    int64_t delayInSeconds = 1.0f;
    dispatch_time_t popTime =
    dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        /* Add the current date to the list of dates that we have
         so that when the table view is refreshed, a new item will appear
         on the screen so that the user will see the difference between
         the before and the after of the refresh */
        NSLog(@"refresh called");
        [self.refreshControl endRefreshing];
        
    });
    
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
    NSLog(@"index %ld", (long)indexPath.row);
    if ([dic[@"isLive" ] isEqual: @false] ) {
        cell.liveImg.hidden = YES;
        cell.redbtn.hidden = YES;
    }else{
        cell.liveImg.hidden = NO;
        cell.redbtn.hidden = NO;
    }
    
    cell.img.image = image;
    cell.title.text = title;
    cell.title.textColor = NTVDarkBlue;
    
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
