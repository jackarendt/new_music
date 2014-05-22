//
//  JAMusicLibraryViewController.m
//  Music Queue
//
//  Created by Jack Arendt on 5/21/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import "JAMusicLibraryViewController.h"
#import "UIImage+ImageEffects.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>

#define IPAD_VERTICAL 1024
#define IPAD_HORIZONTAL 768
#define IPHONE_5_HEIGHT 568
#define IPHONE_4_HEIGHT 480
#define IPHONE_WIDTH 320
#define RIGHT_LANDSCAPE 4
#define LEFT_LANDSCAPE 3
#define PORTRAIT 1
#define UPSIDE_DOWN 2

@interface JAMusicLibraryViewController (){
    UIImageView *background;
    NSMutableArray *songsList;
    NSMutableArray *filteredList;
    BOOL searchActive;
    BOOL isSearching;
}

@property (nonatomic) NSInteger isiPhone;
@property (nonatomic) NSInteger is5;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation JAMusicLibraryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Library";
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchForSong)];
    
    searchActive = NO;
    isSearching = NO;
    
    self.navigationItem.rightBarButtonItem = searchButton;

    NSInteger height = self.view.bounds.size.height;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSArray *itemsFromGenericQuery = [everything items];
    songsList = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
    //3
    [self.tableView reloadData];


    
    if((orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        height = IPAD_HORIZONTAL;
    
    switch (height) {
        case IPHONE_4_HEIGHT:
            [self initViewiPhone:height];
            self.isiPhone = 1;
            self.is5 = 0;
            break;
        case IPHONE_5_HEIGHT:
            [self initViewiPhone:height];
            self.isiPhone = 1;
            self.is5 = 1;
            break;
            
        default:
            [self initViewiPad:height];
            self.isiPhone = 0;
            break;
            
    }
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViewiPhone:(NSInteger)height
{
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    self.tableView = [[UITableView alloc] init];
    self.searchBar = [[UISearchBar alloc] init];
    
    
    self.searchBar.translucent = NO;
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.delegate = self;
    self.searchBar.keyboardType = UIKeyboardAppearanceDark;
    
    
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
    [self rotationHelper:height];
    
    [background.image applyDarkEffect];
    self.tableView.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.5];
    
    [self.view addSubview:background];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchBar];
}

-(void)initViewiPad:(NSInteger)height
{
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    [self rotationHelper:height];
    
    [background.image applyDarkEffect];
    
    [self.view addSubview:background];
}

-(void)rotationHelper:(NSInteger)height
{
    if(height == IPHONE_5_HEIGHT)
    {
        background.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_5_HEIGHT);
        self.tableView.frame = CGRectMake(0, 64, IPHONE_WIDTH, IPHONE_5_HEIGHT-48);
        self.searchBar.frame = CGRectMake(0, 24, 320, 40);
    }
    if(height == IPHONE_4_HEIGHT)
    {
        background.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_4_HEIGHT);
        self.tableView.frame = CGRectMake(0, 64, IPHONE_WIDTH, IPHONE_4_HEIGHT-48);
        self.searchBar.frame = CGRectMake(0, 24, 320, 40);
    }
    if(height == IPAD_HORIZONTAL)
    {
        background.frame = CGRectMake(0, 0, IPAD_VERTICAL, height);
    }
    if(height == IPAD_VERTICAL)
    {
        background.frame = CGRectMake(0, 0, IPAD_HORIZONTAL, height);
    }

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Horizontal orientation
    if(toInterfaceOrientation == LEFT_LANDSCAPE || toInterfaceOrientation == RIGHT_LANDSCAPE)
    {
        if(self.isiPhone && self.is5)
            [self rotationHelper:IPHONE_WIDTH+IPHONE_5_HEIGHT];
        else if(self.isiPhone && !self.is5)
            [self rotationHelper:IPHONE_WIDTH + IPHONE_4_HEIGHT];
        else
            [self rotationHelper:IPAD_HORIZONTAL];
    }
    
    //Vertical orientation
    else if(toInterfaceOrientation == PORTRAIT || toInterfaceOrientation == UPSIDE_DOWN)
    {
        if(self.isiPhone && self.is5)
            [self rotationHelper:IPHONE_5_HEIGHT];
        else if(self.isiPhone && !self.is5)
            [self rotationHelper:IPHONE_4_HEIGHT];
        else
            [self rotationHelper:IPAD_VERTICAL];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearching)
        return [filteredList count];
    return [songsList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    if(!isSearching)
    {
        MPMediaItem *song = [songsList objectAtIndex:indexPath.row];
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSString *artist = [song valueForProperty: MPMediaItemPropertyArtist];
        NSString *album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
        cell.textLabel.text = songTitle;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", artist, album];
    }
    
    if(isSearching)
    {
        MPMediaItem *song = [filteredList objectAtIndex:indexPath.row];
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSString *artist = [song valueForProperty: MPMediaItemPropertyArtist];
        NSString *album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
        cell.textLabel.text = songTitle;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", artist, album];
    }
    
    
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;

}

-(void)searchForSong
{
    if(searchActive)
    {
        if(self.isiPhone && self.is5)
        {
            [UIView animateKeyframesWithDuration:.25 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                self.searchBar.frame = CGRectMake(0, 20, IPHONE_WIDTH, 40);
                self.tableView.frame = CGRectMake(0, 64, IPHONE_WIDTH, IPHONE_5_HEIGHT-48);
            }completion:^(BOOL finished){
                [self.searchBar resignFirstResponder];
            }];
        }
        if(self.isiPhone && !self.is5)
        {
            [UIView animateKeyframesWithDuration:.25 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                self.searchBar.frame = CGRectMake(0, 20, IPHONE_WIDTH, 40);
                self.tableView.frame = CGRectMake(0, 64, IPHONE_WIDTH, IPHONE_4_HEIGHT-48);
            }completion:^(BOOL finished){
                [self.searchBar resignFirstResponder];
            }];
        }
        searchActive = NO;
    }
    else if(!searchActive)
    {
        if(self.isiPhone && self.is5)
        {
            [UIView animateKeyframesWithDuration:.25 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                self.searchBar.frame = CGRectMake(0, 64, IPHONE_WIDTH, 40);
                self.tableView.frame = CGRectMake(0, 104, IPHONE_WIDTH, IPHONE_5_HEIGHT-154);
                [self.searchBar becomeFirstResponder];
                
            }completion:^(BOOL finished){
                        }];
        }
        if(self.isiPhone && !self.is5)
        {
            [UIView animateKeyframesWithDuration:.25 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                self.searchBar.frame = CGRectMake(0, 64, IPHONE_WIDTH, 40);
                self.tableView.frame = CGRectMake(0, 104, IPHONE_WIDTH, IPHONE_4_HEIGHT-154);
                [self.searchBar becomeFirstResponder];
                
            }completion:^(BOOL finished){
            }];

        }
        searchActive = YES;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    unsigned long index = self.navigationController.viewControllers.count-2;
    JACreatorViewController *creatorVC = [self.navigationController.viewControllers objectAtIndex:index];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", creatorVC);
    MPMediaItem *song;
    if(isSearching)
        song = [filteredList objectAtIndex:indexPath.row];
    else
        song = [songsList objectAtIndex:indexPath.row];
    creatorVC.song = song;
    creatorVC.flags = [NSNumber numberWithInt:1];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        isSearching = NO;
        [self.tableView reloadData];
    }
    else
    {
        isSearching = YES;
        filteredList = [[NSMutableArray alloc] init];
        [filteredList removeAllObjects];
        NSMutableArray *names = [[NSMutableArray alloc] init];
        
        for(int i = 0; i< [songsList count]; i++)
        {
            MPMediaItem *song = [songsList objectAtIndex:i];
            [names addObject:[song valueForKey:MPMediaItemPropertyTitle]];
        }
        
        
        for(MPMediaItem *attribute in songsList)
        {
            NSString *title = [attribute valueForKey:MPMediaItemPropertyTitle];
            NSRange titleRange = [title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            NSString *artist = [attribute valueForKey:MPMediaItemPropertyArtist];
            NSRange artistRange = [artist rangeOfString:searchText options:NSCaseInsensitiveSearch];

            NSString *album = [attribute valueForKey:MPMediaItemPropertyAlbumTitle];
            NSRange albumRange = [album rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(titleRange.location != NSNotFound || artistRange.location != NSNotFound || albumRange.location != NSNotFound)
            {
                [filteredList addObject:attribute];
            }
        }
        
        [self.tableView reloadData];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
