//
//  JAPowerListViewController.h
//  Music Queue
//
//  Created by Jack Arendt on 5/13/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JAPowerListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

@end
