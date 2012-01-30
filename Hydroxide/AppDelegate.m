//
//  AppDelegate.m
//  Hydroxide
//
//  Created by Craig Stanford on 30/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "DataManager.h"
#import "Section+Additions.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecordHelpers setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"HydroxideModel"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (![Section hasAtLeastOneEntity]) 
    {
        // Since we need to get the Configuration, lets show a Splash Screen while we wait
        UIViewController* splashViewController = [[UIViewController alloc] init];
        
        // We'll user the Default PNG as a splash, but you can change it to whatever image/view you like
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
        [splashViewController.view addSubview:imageView];
        
        // Add a spinner to let users know we're busy
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = splashViewController.view.center;
        [spinner startAnimating];
        [splashViewController.view addSubview:spinner];
        
        // Put it in the Window & show it
        self.window.rootViewController = splashViewController;
    
        // Add some observers so we know when the Config updates
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(appReady) 
                                                     name:kHydroxideConfigSuccess 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(appFailure) 
                                                     name:kHydroxideConfigFailure 
                                                   object:nil];
        
        [[DataManager sharedDataManager] updateSections];
        
        //TODO: Move this outside the IF statement
        //      Handle changing of config, instead of just wiping it out each time
        
        
    }
    else
        [self appReady];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)appReady
{
    // Check we actually got some sections
    if (![Section hasAtLeastOneEntity]) 
    {
        [self appFailure];
        return;
    }
    
    // Only create the View Controller if we haven't done so already...
    if(!self.viewController)
    {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        self.window.rootViewController = self.viewController;
    }
}

- (void)appFailure
{
    if (![Section hasAtLeastOneEntity]) 
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Unable to get Config" 
                                                       delegate:self 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"Retry", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[DataManager sharedDataManager] updateSections];
}

@end
