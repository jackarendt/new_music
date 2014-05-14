//
//  JACurrentViewController.h
//  Music Queue
//
//  Created by Jack Arendt on 5/13/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JACurrentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *currentSongView;

@end
