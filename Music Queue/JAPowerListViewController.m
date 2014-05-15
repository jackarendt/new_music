//
//  JAPowerListViewController.m
//  Music Queue
//
//  Created by Jack Arendt on 5/13/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import "JAPowerListViewController.h"

@interface JAPowerListViewController ()

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
    
    // Do any additional setup after loading the view.
}


-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)initViewiPhone:(NSInteger)height
{
    
}

-(void)initViewiPad:(NSInteger)height
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
