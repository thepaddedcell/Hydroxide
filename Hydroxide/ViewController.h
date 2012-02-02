//
//  ViewController.h
//  Hydroxide
//
//  Created by Craig Stanford on 30/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView* webView;
@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, retain) NSArray* sections;
@property (nonatomic, retain) UIView* loadingView;

@end
