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
}

@property (nonatomic) NSInteger isiPhone;
@property (nonatomic) NSInteger is5;

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
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
    [self rotationHelper:height];
    
    [background.image applyDarkEffect];
    self.tableView.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.5];
    
    [self.view addSubview:background];
    [self.view addSubview:self.tableView];
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
    }
    if(height == IPHONE_4_HEIGHT)
    {
        background.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_4_HEIGHT);
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
    MPMediaItem *song = [songsList objectAtIndex:indexPath.row];
    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    NSString *artist = [song valueForProperty: MPMediaItemPropertyArtist];
    NSString *album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    
    cell.textLabel.text = songTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", artist, album];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;

}

-(void)searchForSong
{
    
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
