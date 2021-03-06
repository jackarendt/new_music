//
//  JAAppDelegate.m
//  Music Queue
//
//  Created by Jack Arendt on 5/13/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import "JAAppDelegate.h"

@implementation JAAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate=self;
    
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    //[[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    //Now Playing View Controller setup
    
    JACurrentViewController * currentController = [[JACurrentViewController alloc] init];
    currentController.title = @"Now Playing";
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:currentController];
    [firstNav.navigationBar setBarTintColor:[UIColor blackColor]];
    [firstNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:21]}];
    firstNav.navigationBar.tintColor = [UIColor whiteColor];
    bool t = [firstNav.tabBarItem initWithTitle:@"Now Playing" image:[UIImage imageNamed:@"Now-Playing"] tag:1];
    
    //Power Hour View Controller setup
    
    JAPowerListViewController * powerController = [[JAPowerListViewController alloc] init];
    powerController.title = @"Power Hours";
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:powerController];
    t = [secondNav.tabBarItem initWithTitle:@"Power Hours" image:[UIImage imageNamed:@"power"] tag:2];
    [secondNav.navigationBar setBarTintColor:[UIColor blackColor]];
    [secondNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:21]}];
    secondNav.navigationBar.tintColor = [UIColor whiteColor];
    
    //Power Hour Creator View Controller setup
    
    JACreatorViewController *creatorController = [[JACreatorViewController alloc] init];
    creatorController.title = @"Creator";
    UINavigationController *thirdNav = [[UINavigationController alloc] initWithRootViewController:creatorController];
    t = [thirdNav.tabBarItem initWithTitle:@"Creator" image:[UIImage imageNamed:@"Create"] tag:3];
    [thirdNav.navigationBar setBarTintColor:[UIColor blackColor]];
    [thirdNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:21]}];
    thirdNav.navigationBar.tintColor = [UIColor whiteColor];
    
    //Adding vcs to tab bar controller
    
    NSArray* controllers = [NSArray arrayWithObjects:firstNav, secondNav, thirdNav, nil];
    tabBarController.viewControllers = controllers;
    
    [self.window addSubview:tabBarController.view];
    
    self.window.rootViewController = tabBarController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Music_Queue" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Music_Queue.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if(tabBarController.selectedIndex == 0)
            return UIInterfaceOrientationMaskAllButUpsideDown;
        else
            return UIInterfaceOrientationMaskPortrait;
    }
    else
        return UIInterfaceOrientationMaskAll;
}

@end
