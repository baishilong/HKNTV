//
//  FirstViewController.m
//  HKNTV
//
//  Created by ZhiYou on 11/2/14.
//  Copyright (c) 2014 ZhiYou. All rights reserved.
//  https://github.com/judeyouzhi/HKNTV

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "MyAVPlayerViewController.h"
#import "NTVColor.h"
#import "AFHTTPRequestOperation.h"
#import "PlayerViewController.h"
@interface HomeViewController ()

@property (nonatomic,strong) NSMutableArray *names;
@property (nonatomic,strong) NSArray *keys;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

#define MAX_ITEMS 29

- (void) requestCatergry{
    NSString *sohuUrl = @"http://api.tv.sohu.com/v4/mobile/channelPageData/list.json?cate_code=0&plat=6&poid=1&api_key=9854b2afa779e1a6bff1962447a09dbd&sver=4.6.2&act=1&sysver=4.4.2&partner=44";
    NSURL *url = [NSURL URLWithString:sohuUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        self.keys = (NSArray *)responseObject;
        self.title = @"JSON Retrieved";
        [self.liveCollection reloadData];
        NSLog(@"JSON Retrieved");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        NSLog(@"JSON errored");
        [alertView show];
    }];
    
    // 5
    [operation start];
}

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

- (void) viewWillAppear:(BOOL)animated
{
    [self requestCatergry];
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad home");
    [super viewDidLoad];
    [self setupNameArray];
    [self setUpCollection];
    [self requestCatergry];
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
        [self requestCatergry];
        [self.refreshControl endRefreshing];
        
    });
    
}



#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(self.keys == nil){
        return 0;
    }
    //    NSLog(@"numberOfSectionsInTableView %lu", [[(unsigned long)[[self.keys valueForKeyPath:@"data.columns"] objectAtIndex:1] valueForKey:@"video_list"] count]);
    //    return [[self.keys valueForKeyPath:@"data.columns.video_list"] count];
    return 8;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.keys == nil){
        return 0;
    }
    switch (section) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        default:
            return [[[self.keys valueForKeyPath:@"data.columns.video_list"] objectAtIndex:section] count];
            break;
    }
    return [[[self.keys valueForKeyPath:@"data.columns.video_list"] objectAtIndex:section] count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.keys == nil){
        return 0;
    }
    static NSString *collectionCellID = @"live_cell";
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            NSURL *url = [NSURL URLWithString:[[[[self.keys valueForKeyPath:@"data.columns.video_list"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"ver_common_pic"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            NSDictionary *dic    = self.dataMArr[indexPath.row];
            UIImage *image       = dic[@"image"];
            NSString *title      = dic[@"title"];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.responseSerializer = [AFImageResponseSerializer serializer];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                cell.img.image = (UIImage *) responseObject;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
            }];
            [operation start];
            
            
            //            NSLog(@"index %ld", (long)indexPath.row);
            //            if ([dic[@"isLive" ] isEqual: @false] ) {
            //                cell.liveImg.hidden = YES;
            //                cell.redbtn.hidden = YES;
            //            }else{
            //                cell.liveImg.hidden = NO;
            //                cell.redbtn.hidden = NO;
            //            }
            
            cell.img.image = image;
            cell.title.text = title;
            cell.title.textColor = NTVDarkBlue;
        }
            break;
        case 1:
        {
            NSURL *url = [NSURL URLWithString:[[[[self.keys valueForKeyPath:@"data.columns.video_list"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"ver_common_pic"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            NSDictionary *dic    = self.dataMArr[indexPath.row];
            UIImage *image       = dic[@"image"];
            NSString *title      = dic[@"title"];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.responseSerializer = [AFImageResponseSerializer serializer];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                cell.img.image = (UIImage *) responseObject;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
            }];
            [operation start];
            
            
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
        }
            break;
        default:
            break;
    }
    
    
    return cell;
};


#pragma mark - Collection daleagte


- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected %ld in live collection view", indexPath.row);
    self.selected_id = indexPath.row;
    
    NSString *desc       = [[[[self.keys valueForKeyPath:@"data.columns.video_list"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"tv_desc"];
    self.selected_str = desc;
    return YES;
}

#pragma mark - Others

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //    if ([segue.identifier isEqualToString:@"pushLivePlayer"]){ MyAVPlayerViewController *playerController = segue.destinationViewController;
    //        [playerController setProg_id:self.selected_id];
    //        [playerController setProg_desc:self.selected_str];
    //    }
    if ([segue.identifier isEqualToString:@"push2DetailPage"]) {
        PlayerViewController *playerController = segue.destinationViewController;
        [playerController setProg_desc:self.selected_str];
    }
}

@end
