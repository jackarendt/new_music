//
//  JACreatorViewController.m
//  Music Queue
//
//  Created by Jack Arendt on 5/13/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import "JACreatorViewController.h"
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

@interface JACreatorViewController ()
{
    UIImageView *background;
    UITextField *titleTextField;
    UIButton *createButton;
    UILabel *description;
    UILabel *titleLabel;
    UILabel *numberOfSongs;
    UIButton *hideKeyboard;
    NSInteger numSongs;
    BOOL started;
    BOOL finished;
    UIBarButtonItem *editButton;
    UIBarButtonItem *addButton;
    UIBarButtonItem *saveButton;
    BOOL inProgress;
}

@property (nonatomic) NSInteger isiPhone;
@property (nonatomic) NSInteger is5;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JACreatorViewController

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
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    self.navigationItem.backBarButtonItem.title = @" ";
    self.navigationController.
    self.view.backgroundColor = [UIColor darkGrayColor];
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    [background.image applyDarkEffect];
    
    editButton =[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPowerHour)];
    
    addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSong)];
    saveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] landscapeImagePhone:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(savePowerHour)];
    //self.navigationItem.leftBarButtonItem = button;
    
    NSInteger height = self.view.bounds.size.height;
    
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
    //Allocations
    background =        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    titleTextField =    [[UITextField alloc] init];
    createButton =      [[UIButton alloc] init];
    description =       [[UILabel alloc] init];
    titleLabel =        [[UILabel alloc] init];
    numberOfSongs =     [[UILabel alloc] init];
    hideKeyboard =      [[UIButton alloc] init];
    self.tableView =    [[UITableView alloc] init];

    [hideKeyboard addTarget:self action:@selector(hideKey) forControlEvents:UIControlEventTouchUpInside];
    [createButton addTarget:self action:@selector(createPowerHour) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Text Field setup
    titleTextField.borderStyle = UITextBorderStyleLine;
    titleTextField.placeholder = @"new power hour";
    titleTextField.returnKeyType = UIReturnKeyGo;
    titleTextField.textColor = [UIColor whiteColor];
    titleTextField.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
    titleTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    titleTextField.delegate = self;
    titleTextField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0];
    titleTextField.textAlignment = NSTextAlignmentCenter;
    
    //Create Button setup
    createButton.backgroundColor = [UIColor colorWithRed:.8 green:.254 blue:.211 alpha:1.0];
    [createButton setTitle:@"create" forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createButton.layer.masksToBounds = YES;
    createButton.layer.cornerRadius = 5.0;
    
    //Title label setup
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setHidden:YES];
    
    numberOfSongs.textColor = [UIColor whiteColor];
    numberOfSongs.text = @"0 Songs";
    numberOfSongs.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0];
    numberOfSongs.textAlignment = NSTextAlignmentCenter;
    [numberOfSongs setHidden:YES];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.5];
    
    [background.image applyDarkEffect];
    
    //Setup frames
    [self rotationHelper:height];
    
    //Add to subview
    [self.view addSubview:background];
    [self.view addSubview:hideKeyboard];
    [self.view addSubview:titleTextField];
    [self.view addSubview:titleLabel];
    [self.view addSubview:createButton];
    [self.view addSubview:description];
    [self.view addSubview:titleLabel];
    [self.view addSubview:numberOfSongs];
    [self.view addSubview:self.tableView];
    
    
}

-(void)initViewiPad:(NSInteger)height
{
    background =        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songbackground.jpg"]];
    titleTextField =    [[UITextField alloc] init];
    createButton =      [[UIButton alloc] init];
    description =       [[UILabel alloc] init];
    titleLabel =        [[UILabel alloc] init];
    numberOfSongs =     [[UILabel alloc] init];
    
    [background.image applyDarkEffect];
    //Setup frames
    [self rotationHelper:height];
    //Add to subview
    [self.view addSubview:background];
    [self.view addSubview:titleTextField];
    [self.view addSubview:createButton];
    [self.view addSubview:titleLabel];
    [self.view addSubview:description];
    [self.view addSubview:titleLabel];
    [self.view addSubview:numberOfSongs];
    [self.view addSubview:hideKeyboard];
}

-(void)rotationHelper:(NSInteger)height
{
    if(height == IPHONE_5_HEIGHT)
    {
        background.frame = CGRectMake(0, 0, IPHONE_WIDTH, height);
        titleTextField.frame = CGRectMake(10, IPHONE_5_HEIGHT/2-25, 300, 50);
        createButton.frame = CGRectMake(60, IPHONE_5_HEIGHT/2 + 40, 200, 44);
        hideKeyboard.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_5_HEIGHT);
        self.tableView.frame = CGRectMake(0, IPHONE_5_HEIGHT, IPHONE_WIDTH, 368);
    }
    if(height == IPHONE_4_HEIGHT)
    {
        background.frame = CGRectMake(0, 0, IPHONE_WIDTH, height);
        titleTextField.frame = CGRectMake(10, IPHONE_4_HEIGHT/2-25, 300, 50);
        createButton.frame = CGRectMake(60, IPHONE_5_HEIGHT/2 + 40, 200, 44);
        hideKeyboard.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_5_HEIGHT);
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

-(void)hideKey
{
    if(!inProgress)
    {
        if(self.isiPhone && self.is5)
        {
            [UIView animateKeyframesWithDuration:.25 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                titleTextField.frame = CGRectMake(10, IPHONE_5_HEIGHT/2-25, 300, 50);
                createButton.frame = CGRectMake(60, IPHONE_5_HEIGHT/2 +40, 200, 44);
            }
                                      completion:nil];
        }
    }
    else
        [self saveNewTitle];

    [titleTextField resignFirstResponder];
}

-(void)createPowerHour
{
    inProgress = YES;
    [hideKeyboard setHidden:YES];
    titleLabel.frame = titleTextField.frame;
    titleLabel.text = titleTextField.text;
    numberOfSongs.frame = CGRectMake(10, 120, 300, 30);
    numberOfSongs.alpha = 0;
    [titleLabel setHidden:NO];
    [numberOfSongs setHidden:NO];
    self.navigationItem.leftBarButtonItem = editButton;
    
    NSArray *arr = [[NSArray alloc] initWithObjects:addButton, saveButton, nil];
    self.navigationItem.rightBarButtonItems = arr;
    
    
    [UIView animateKeyframesWithDuration:.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        titleTextField.alpha = 0;
        createButton.alpha = 0;
        
    }
    completion:^(BOOL finished){
        
        [UIView animateKeyframesWithDuration:.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            titleLabel.frame = CGRectMake(10, 75, 300, 30);
            self.tableView.frame = CGRectMake(0, IPHONE_5_HEIGHT-368, 320, 368);
            titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
            numberOfSongs.alpha = 1;
        }completion:nil];
        
                              }];
    [titleTextField resignFirstResponder];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [titleTextField resignFirstResponder];
    if(!inProgress)
        [self createPowerHour];
    else
        [self saveNewTitle];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [hideKeyboard setHidden:NO];
    if(self.isiPhone && self.is5)
    {
        [UIView animateKeyframesWithDuration:.25 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            titleTextField.frame = CGRectMake(10, IPHONE_5_HEIGHT/2-75, 300, 50);
            createButton.frame = CGRectMake(60, IPHONE_5_HEIGHT/2 - 10, 200, 44);
        }
        completion:nil];
    }
    
    if(inProgress)
    {
        if(self.isiPhone && self.is5)
        {
            [UIView animateKeyframesWithDuration:.25 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                self.tableView.frame = CGRectMake(0, IPHONE_5_HEIGHT, 320, 368);
                numberOfSongs.alpha = 0;
                titleLabel.frame = titleTextField.frame;
            }
                                      completion:nil];
        }
    }
}

-(void)editPowerHour
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.title = @"";
    titleTextField.frame = CGRectMake(titleLabel.frame.origin.x, 65, 300, 50);
    titleTextField.alpha = 1;
    titleLabel.alpha = 0;
    titleTextField.text = titleLabel.text;
    
}

-(void)addSong
{
    
}

-(void)savePowerHour
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.title = @"Edit";
    [self saveNewTitle];
}

-(void)saveNewTitle
{
    titleLabel.text = titleTextField.text;
    titleLabel.alpha = 1;
    titleTextField.alpha = 0;
    [titleTextField resignFirstResponder];
    
    if(self.isiPhone && self.is5)
    {
        [UIView animateKeyframesWithDuration:.25 delay:.25 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            self.tableView.frame = CGRectMake(0, 200, 320, 368);
            numberOfSongs.alpha = 1;
            titleLabel.frame = CGRectMake(10, 75, 300, 30);
        }
                                  completion:nil];
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"YO";
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
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
