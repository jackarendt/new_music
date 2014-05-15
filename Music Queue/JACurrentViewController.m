//
//  JACurrentViewController.m
//  Music Queue
//
//  Created by Jack Arendt on 5/13/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import "JACurrentViewController.h"
#import "JAAlbumView.h"
#import "PWProgressView.h"
#import "UIImage+ImageEffects.h"
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

@interface JACurrentViewController (){
    UIImageView *background;
    UIImageView *albumCover;
    UILabel *title;
    UILabel *artist;
    UILabel *album;
    UILabel *totalTime;
    UILabel *iPadArtistAlbumLabel;
    UIView *albumView;
    NSTimer *timer;
    NSInteger progress;
}

@property (nonatomic) NSInteger isiPhone;
@property (nonatomic) NSInteger is5;
@property (nonatomic, strong) JAAlbumView *cover;

@end

@implementation JACurrentViewController

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
    NSInteger height = self.view.bounds.size.height;
    timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(setNewProgress) userInfo:nil repeats:YES];
    progress = 0;
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
    
    UIBarButtonItem *button =[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPowerHour)];
    self.navigationItem.leftBarButtonItem = button;
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger height = self.view.bounds.size.height;
    [self rotationHelper:height];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViewiPhone:(NSInteger)height
{
    //Allocations
    self.cover = [[JAAlbumView alloc] init];
    albumView = [[UIView alloc] init];
    self.currentSongView = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.cover.imageView.image = [UIImage imageNamed:@"demoCover.jpg"];

    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    album = [[UILabel alloc] init];
    totalTime = [[UILabel alloc] init];
    title = [[UILabel alloc] init];
    artist = [[UILabel alloc] init];
    
    //Setting up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    [image.image applyDarkEffect];
    self.tableView.backgroundView = image;
    self.tableView.bounces = NO;
    
    
    //Set up frames for UI elements
    [self rotationHelper:height];
    
    
    //Label setup
    totalTime.textColor = [UIColor whiteColor];
    totalTime.textAlignment = NSTextAlignmentCenter;
    totalTime.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:50];
    
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    
    artist.textColor = [UIColor whiteColor];
    artist.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    album.textColor = [UIColor whiteColor];
    album.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    
    //CHANGE THESE
    totalTime.text = @"60:00";
    title.text = @"Homecoming";
    artist.text = @"Kanye West";
    album.text = @"Graduation";
    
    albumView = self.cover;
    
    //Adding to subviews
    [self.currentSongView addSubview:background];
    [self.currentSongView addSubview:albumCover];
    [self.currentSongView addSubview:totalTime];
    [self.currentSongView addSubview:title];
    [self.currentSongView addSubview:artist];
    [self.currentSongView addSubview:album];
    [self.currentSongView addSubview:albumView];
    
    [self.view addSubview:self.currentSongView];
    [self.view addSubview:self.tableView];
    
    
}

-(void)initViewiPad:(NSInteger)orientation
{
    //Allocations
    self.currentSongView = [[UIView alloc] init];
    self.cover = [[JAAlbumView alloc] init];
    albumView = [[UIView alloc] init];
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    self.tableView = [[UITableView alloc] init];
    self.cover.imageView.image = [UIImage imageNamed:@"demoCover.jpg"];
    totalTime = [[UILabel alloc] init];
    title = [[UILabel alloc] init];
    iPadArtistAlbumLabel = [[UILabel alloc] init];
    
    //Setup Frame
    [self rotationHelper:orientation];
    
    //Setup tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    [image.image applyDarkEffect];
    self.tableView.backgroundView = image;
    self.tableView.bounces = NO;
    
    //Set up Text Attributes
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    
    iPadArtistAlbumLabel.textColor = [UIColor whiteColor];
    iPadArtistAlbumLabel.textAlignment = NSTextAlignmentCenter;
    iPadArtistAlbumLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    totalTime.textColor = [UIColor whiteColor];
    totalTime.textAlignment = NSTextAlignmentCenter;
    totalTime.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:50];
    
    
    //Change These
    totalTime.text = @"60:00";
    title.text = @"Homecoming";
    iPadArtistAlbumLabel.text = @"Kanye West - Graduation";
    
    albumView = self.cover;
    
    //Add to subviews
    [self.currentSongView addSubview:background];
    [self.currentSongView addSubview:albumCover];
    [self.currentSongView addSubview:totalTime];
    [self.currentSongView addSubview:title];
    [self.currentSongView addSubview:iPadArtistAlbumLabel];
    [self.currentSongView addSubview:albumView];
    
    [self.view addSubview:self.currentSongView];
    [self.view addSubview:self.tableView];
    

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Horizontal orientation
    if(toInterfaceOrientation == LEFT_LANDSCAPE || toInterfaceOrientation == RIGHT_LANDSCAPE)
    {
        if(self.isiPhone)
            [self rotationHelper:IPHONE_WIDTH];
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

-(void)rotationHelper:(NSInteger)height
{
    if(height == IPAD_HORIZONTAL)
    {
        self.currentSongView.frame = CGRectMake(0, 64, IPAD_VERTICAL, 300);
        background.frame = CGRectMake(0, 0, IPAD_VERTICAL, 300);
        self.tableView.frame = CGRectMake(0, 364, IPAD_VERTICAL, 348);
        totalTime.frame = CGRectMake(0, 80, IPAD_VERTICAL, 50);
        title.frame = CGRectMake(0, 150, IPAD_VERTICAL, 30);
        iPadArtistAlbumLabel.frame = CGRectMake(0, 180, IPAD_VERTICAL, 30);
        
        [self.cover changeLayout:IPAD_HORIZONTAL];
        
    }
    else if(height == IPAD_VERTICAL)
    {
        self.currentSongView.frame = CGRectMake(0, 64, IPAD_HORIZONTAL, 400);
        background.frame = CGRectMake(0, 0, IPAD_HORIZONTAL, 400);
        self.tableView.frame = CGRectMake(0, 464, IPAD_HORIZONTAL, 504);
        totalTime.frame = CGRectMake(0, 240, IPAD_HORIZONTAL, 50);
        title.frame = CGRectMake(0, 320, IPAD_HORIZONTAL, 30);
        iPadArtistAlbumLabel.frame = CGRectMake(0, 350, IPAD_HORIZONTAL, 30);
        
        [self.cover changeLayout:IPAD_VERTICAL];
    }
    else if(height == IPHONE_5_HEIGHT)
    {
        self.currentSongView.frame = CGRectMake(0, 64, IPHONE_WIDTH, 200);
        self.tableView.frame = CGRectMake(0, 264, 320, 256);
        background.frame = CGRectMake(0, 0, IPHONE_WIDTH, 200);
        totalTime.frame = CGRectMake(0, 10, IPHONE_WIDTH, 50);
        title.frame = CGRectMake(130, 80, 190, 30);
        artist.frame = CGRectMake(130, 110, 190, 30);
        album.frame = CGRectMake(130, 140, 190, 30);
        
        [self.cover changeLayout:IPHONE_5_HEIGHT];
        
        [self.navigationController setNavigationBarHidden:NO];
        [self.tabBarController.tabBar setHidden:NO];
        [self.tableView setHidden:NO];

    }
    else if(height == IPHONE_4_HEIGHT)
    {
        self.currentSongView.frame = CGRectMake(0, 64, IPHONE_WIDTH, 150);
        self.tableView.frame = CGRectMake(0, 264, IPHONE_WIDTH, 188);
        background.frame = CGRectMake(0, 0, IPHONE_WIDTH, 200);
        totalTime.frame = CGRectMake(0, 10, IPHONE_WIDTH, 50);
        title.frame = CGRectMake(130, 80, 190, 30);
        artist.frame = CGRectMake(130, 110, 190, 30);
        album.frame = CGRectMake(130, 140, 190, 30);
        
        [self.cover changeLayout:IPHONE_4_HEIGHT];
        
        [self.navigationController setNavigationBarHidden:NO];
        [self.tabBarController.tabBar setHidden:NO];
        [self.tableView setHidden:NO];
    }
    
    else if(height == IPHONE_WIDTH && self.is5)
    {
        [self.tableView setHidden:YES];
        [self.navigationController setNavigationBarHidden:YES];
        [self.tabBarController.tabBar setHidden:YES];
        
        self.currentSongView.frame = CGRectMake(0, 0, IPHONE_5_HEIGHT, IPHONE_WIDTH);
        background.frame = CGRectMake(0, 0, IPHONE_5_HEIGHT, IPHONE_WIDTH);
        
        [self.cover changeLayout:IPHONE_5_HEIGHT+IPHONE_WIDTH];
        
        totalTime.frame = CGRectMake(200, 25, IPHONE_5_HEIGHT/2, 50);
        title.frame = CGRectMake(IPHONE_5_HEIGHT/2, 120, IPHONE_5_HEIGHT/2, 30);
        artist.frame = CGRectMake(IPHONE_5_HEIGHT/2, 150, IPHONE_5_HEIGHT/2, 30);
        album.frame = CGRectMake(IPHONE_5_HEIGHT/2, 180, IPHONE_5_HEIGHT/2, 30);
    }
    else if(height == IPHONE_WIDTH && !self.is5)
    {
        [self.tableView setHidden:YES];
        [self.navigationController setNavigationBarHidden:YES];
        [self.tabBarController.tabBar setHidden:YES];
        
        self.currentSongView.frame = CGRectMake(0, 0, IPHONE_4_HEIGHT, IPHONE_WIDTH);
        background.frame = CGRectMake(0, 0, IPHONE_4_HEIGHT, IPHONE_WIDTH);
        totalTime.frame = CGRectMake(180, 25, 232, 50);
        title.frame = CGRectMake(IPHONE_4_HEIGHT/2, 120, 232, 30);
        artist.frame = CGRectMake(IPHONE_4_HEIGHT/2, 150, 232, 30);
        album.frame = CGRectMake(IPHONE_4_HEIGHT/2, 180, 232, 30);
        
        [self.cover changeLayout:IPHONE_4_HEIGHT+IPHONE_WIDTH];
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //To be changed
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //Change this please
    cell.textLabel.text = @"Homecoming";
    cell.detailTextLabel.text = @"Kanye West - Graudation";
    cell.imageView.image = [UIImage imageNamed:@"demoCover.jpg"];
    
    cell.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.5];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 22;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView setEditing:YES animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)editPowerHour
{
    
}

-(void)setNewProgress
{
    progress++;
    if(progress >= 300)
        progress = 0;
    
    float prog = (float)progress/(300);
    [self.cover.progressView setProgress:prog];
}

@end
