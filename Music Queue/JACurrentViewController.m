//
//  JACurrentViewController.m
//  Music Queue
//
//  Created by Jack Arendt on 5/13/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import "JACurrentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface JACurrentViewController (){
    UIImageView *background;
    UIImageView *albumCover;
    UILabel *title;
    UILabel *artist;
    UILabel *album;
    UILabel *totalTime;
}

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
    
    switch (height) {
        case 480:
            [self initViewiPhoneFour];
            break;
        case 568:
            [self initViewiPhoneFive];
            break;
            
        default:
            [self initViewiPad:height];
            break;
    }
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger height = self.view.bounds.size.height;
    if(height == 768 || height == 1024)
        [self rotationHelper:height];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViewiPhoneFive
{
    self.currentSongView = [[UIView alloc] init];
    self.currentSongView.frame = CGRectMake(0, 64, 320, 200);
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 264, 320, 256);
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    background.frame = CGRectMake(0, 0, 320, 200);
    
    albumCover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demoCover.jpg"]];
    albumCover.frame = CGRectMake(15, 75, 100, 100);
    albumCover.layer.masksToBounds = YES;
    albumCover.layer.cornerRadius = 50;
    
    totalTime = [[UILabel alloc] init];
    totalTime.frame = CGRectMake(0, 10, 320, 50);
    totalTime.text = @"60:00";
    totalTime.textColor = [UIColor whiteColor];
    totalTime.textAlignment = NSTextAlignmentCenter;
    totalTime.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:50];
    
    title = [[UILabel alloc] init];
    title.frame = CGRectMake(130, 80, 190, 30);
    title.text = @"Homecoming";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    
    artist = [[UILabel alloc] init];
    artist.frame = CGRectMake(130, 110, 190, 30);
    artist.text = @"Kanye West";
    artist.textColor = [UIColor whiteColor];
    artist.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    album = [[UILabel alloc] init];
    album.frame = CGRectMake(130, 140, 190, 30);
    album.text = @"Graduation";
    album.textColor = [UIColor whiteColor];
    album.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    
    [self.currentSongView addSubview:background];
    [self.currentSongView addSubview:albumCover];
    [self.currentSongView addSubview:totalTime];
    [self.currentSongView addSubview:title];
    [self.currentSongView addSubview:artist];
    [self.currentSongView addSubview:album];
    
    [self.view addSubview:self.currentSongView];
    [self.view addSubview:self.tableView];
    
}

-(void)initViewiPhoneFour
{
    self.currentSongView = [[UIView alloc] init];
    self.currentSongView.frame = CGRectMake(0, 64, 320, 150);
    
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    background.frame = CGRectMake(0, 0, 320, 200);
    
    albumCover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demoCover.jpg"]];
    albumCover.frame = CGRectMake(25, 75, 100, 100);
    albumCover.layer.masksToBounds = YES;
    albumCover.layer.cornerRadius = 50;
    
    [self.currentSongView addSubview:background];
    [self.currentSongView addSubview:albumCover];
    [self.view addSubview:self.currentSongView];
    
    

}

-(void)initViewiPad:(NSInteger)orientation
{
    self.currentSongView = [[UIView alloc] init];
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    
    if(orientation == 768) // horizontal
    {
        self.currentSongView.frame = CGRectMake(0, 64, 1024, 300);
        background.frame = CGRectMake(0, 0, 1024, 300);
    }
    
    else // vertical
    {
        self.currentSongView.frame = CGRectMake(0, 64, 768, 400);
        background.frame = CGRectMake(0, 0, 768, 400);
    }
    
    [self.currentSongView addSubview:background];
    [self.view addSubview:self.currentSongView];

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == 3 || toInterfaceOrientation == 4)
    {
        [self rotationHelper:768];
    }
    else
    {
        [self rotationHelper:1024];
    }
}

-(void)rotationHelper:(NSInteger)height
{
    if(height == 768)
    {
        self.currentSongView.frame = CGRectMake(0, 64, 1024, 300);
        background.frame = CGRectMake(0, 0, 1024, 300);
    }
    else
    {
        self.currentSongView.frame = CGRectMake(0, 64, 768, 400);
        background.frame = CGRectMake(0, 0, 768, 400);
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Homecoming";
    cell.detailTextLabel.text = @"Kanye West - Graudation";
    cell.imageView.image = [UIImage imageNamed:@"demoCover.jpg"];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 22;
    
    return cell;
}

-(void)editPowerHour
{
    
}

@end
