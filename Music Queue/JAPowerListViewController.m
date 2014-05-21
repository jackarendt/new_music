//
//  JAPowerListViewController.m
//  Music Queue
//
//  Created by Jack Arendt on 5/13/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import "JAPowerListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImageEffects.h"
#define IPAD_VERTICAL 1024
#define IPAD_HORIZONTAL 768
#define IPHONE_5_HEIGHT 568
#define IPHONE_4_HEIGHT 480
#define IPHONE_WIDTH 320
#define RIGHT_LANDSCAPE 4
#define LEFT_LANDSCAPE 3
#define PORTRAIT 1
#define UPSIDE_DOWN 2


@interface JAPowerListViewController (){
    
}

@property (nonatomic) NSInteger isiPhone;
@property (nonatomic) NSInteger is5;
@end

@implementation JAPowerListViewController


@synthesize tableView = _tableView;

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
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    self.navigationItem.backBarButtonItem.title = @" ";
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    NSInteger height = self.view.bounds.size.height;
    NSInteger width = self.view.bounds.size.width;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
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
        case IPHONE_WIDTH:
            if(width == IPHONE_5_HEIGHT)
            {
                self.isiPhone = 1;
                self.is5 = 1;
            }
            else
            {
                self.isiPhone = 1;
                self.is5 = 0;
            }
            [self initViewiPhone:height + IPHONE_WIDTH];
            break;
            
        default:
            [self initViewiPad:height];
            self.isiPhone = 0;
            break;
            
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initViewiPhone:(NSInteger)height
{
    self.tableView = [[UITableView alloc] init];

    [self rotationHelper:height];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    [image.image applyDarkEffect];
    [image.image applyTintEffectWithColor:[UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.5]];
    self.tableView.backgroundView = image;
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    
    
    [self.view addSubview:self.tableView];
}

-(void)initViewiPad:(NSInteger)height
{
    self.tableView = [[UITableView alloc] init];
    
    [self rotationHelper:height];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    [image.image applyDarkEffect];
    self.tableView.backgroundView = image;
    
    [self.view addSubview:self.tableView];
}

-(void)rotationHelper:(NSInteger)height
{
    if(height == IPHONE_5_HEIGHT)
    {
        self.tableView.frame = CGRectMake(0, 0, IPHONE_WIDTH, height);
    }
    if(height == IPHONE_4_HEIGHT)
    {
        self.tableView.frame = CGRectMake(0, 0, IPHONE_WIDTH, height);
    }
    if(height == IPAD_VERTICAL)
    {
        self.tableView.frame = CGRectMake(0, 0, IPAD_HORIZONTAL, IPAD_VERTICAL-56);
    }
    if(height == IPAD_HORIZONTAL)
    {
        self.tableView.frame = CGRectMake(0 , 0, IPAD_VERTICAL, IPAD_HORIZONTAL-56);
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
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"YO";
    
    return cell;

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
