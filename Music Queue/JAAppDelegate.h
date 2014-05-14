//
//  JAAppDelegate.h
//  Music Queue
//
//  Created by Jack Arendt on 5/13/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JARootViewController.h"
#import "JAFirstViewController.h"
#import "JASecondViewController.h"


@interface JAAppDelegate : UIResponder <UIApplicationDelegate> {
    UITabBarController *tabBarController;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
