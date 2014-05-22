//
//  JAMusicLibraryViewController.h
//  Music Queue
//
//  Created by Jack Arendt on 5/21/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JACreatorViewController.h"

@interface JAMusicLibraryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
