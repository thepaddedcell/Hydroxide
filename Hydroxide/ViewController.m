//
//  ViewController.m
//  Hydroxide
//
//  Created by Craig Stanford on 30/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Section+Additions.h"

@implementation ViewController

@synthesize webView=_webView;
@synthesize tableView=_tableView;
@synthesize sections=_sections;
@synthesize loadingView=_loadingView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sections = [Section findAllSortedBy:@"position" ascending:YES];
    Section* section = [self.sections objectAtIndex:0];
    [self.webView loadRequest:section.urlRequest];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - UITableView Datasource + Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"kHydroxideSectionCell";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    Section* section = [self.sections objectAtIndex:indexPath.row];
    cell.textLabel.text = section.title;
    cell.textLabel.textColor = [UIColor colorWithWhite:0.8f alpha:1.f];
    
//    cell.detailTextLabel.text = section.subtitle;
//    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Section* section = [self.sections objectAtIndex:indexPath.row];
    [self.webView loadRequest:section.urlRequest];
    
    //TODO: Refactor this animation code
    if (self.webView.frame.origin.x != 0) 
    {
        CGRect frame = self.webView.frame;
        frame.origin.x = 0;
        [UIView animateWithDuration:0.3f 
                         animations:^{
                             self.webView.frame = frame;
                         }];
    }
}

#pragma mark - UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // Add any loading views/animations here to distract the user while the page loads 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Remove loading views/animate into the view here
    // - Be aware, this method CAN fire before the page is actually rendered, especially
    //   if there is Javascript on the page
    
    // On load, we display the tableview a little until the webview finishes loading
    // - to give the users a big hint that the Navigation is under here
    if (self.webView.frame.origin.x != 0) 
    {
        CGRect frame = self.webView.frame;
        frame.origin.x = 0;
        [UIView animateWithDuration:0.3f 
                         animations:^{
                             self.webView.frame = frame;
                         }];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldLoad = YES;
    // This is where we hijack web requests to decide what to do with them
    switch (navigationType) 
    {
        case UIWebViewNavigationTypeLinkClicked:
        {
            // This is where you catch Clicked links
            NSLog(@"Clicked");
            break;
        }   
        case UIWebViewNavigationTypeOther:
        {    
            // When you generate a load URL Request or change an Anchor tag
            NSArray* urlParts = [request.URL.absoluteString componentsSeparatedByString:@"://"];
            if ([[urlParts objectAtIndex:0] isEqualToString:@"native"]) 
            {
                // This is a message directed at us
                NSString* message = [urlParts objectAtIndex:1];
                if ([message isEqualToString:@"menu"]) 
                {
                    CGRect frame = self.webView.frame;
                    
                    if (frame.origin.x == 0)
                        frame.origin.x = 150;
                    else
                        frame.origin.x = 0;
                    
                    [UIView animateWithDuration:0.3f 
                                     animations:^{
                                         self.webView.frame = frame;
                                         //TODO : Add button / swipe / pan gesture to allow moving back
                                     }];
                }
                else if([message isEqualToString:@"addsubview"])
                {
                    if (!self.loadingView) 
                        self.loadingView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
                    self.loadingView.center = self.view.center;
                    self.loadingView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7f];
                    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    [spinner startAnimating];
                    [self.loadingView addSubview:spinner];
                    [self.view addSubview:self.loadingView];                    
                }
                else if([message isEqualToString:@"removesubview"])
                {
                    [self.loadingView removeFromSuperview];
                }
                else if([message rangeOfString:@"height"].location != NSNotFound)
                {
                    NSArray* info = [message componentsSeparatedByString:@"&"];
                    CGFloat height = [[[[info objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1] floatValue];
                    CGFloat speed = [[[[info objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] floatValue];
                    [UIView animateWithDuration:speed animations:^{
                        CGRect frame = self.webView.frame;
                        frame.size.height = height;
                        self.webView.frame = frame;
                    }];
                }
                else if([message isEqualToString:@"map"])
                {
                    MKMapView* mapView = [[MKMapView alloc] initWithFrame:self.webView.frame];
                    mapView.showsUserLocation = YES;
                    mapView.delegate = self;
                    
                    UIViewController* mapViewController = [[UIViewController alloc] init];
                    [mapViewController.view addSubview:mapView];
                    
                    UINavigationController* mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
                    mapNavigationController.navigationBar.barStyle = UIBarStyleBlack;
                    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalViewControllerAnimated:)];
                    mapViewController.navigationItem.rightBarButtonItem = doneButton;
                    
                    [self presentModalViewController:mapNavigationController animated:YES];
                }
                
                shouldLoad = NO;
            }
            break;
        }   
        case UIWebViewNavigationTypeReload:
            // When you call reload - These are generally not used
            NSLog(@"Reload");
            break;
            
        case UIWebViewNavigationTypeBackForward:
            // Override here to prevent Javascript events forcing the Webview Back/Forward
            NSLog(@"Back Forward");
            break;
            
        case UIWebViewNavigationTypeFormSubmitted:
        case UIWebViewNavigationTypeFormResubmitted:
            // When a user submits an HTML Form
            NSLog(@"Form submission");
            break;
        
        default:
            break;
    }
    return shouldLoad;    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Place any special code here to handle when your web requests fail
    // - things like removing loading views, prompting the user to check their connection etc 
    NSLog(@"WebView Failed: %@", error);
}

#pragma mark - MapView Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, 
                                              MKCoordinateSpanMake(userLocation.location.horizontalAccuracy, 
                                                                   userLocation.location.horizontalAccuracy)) 
              animated:YES];
}

@end
