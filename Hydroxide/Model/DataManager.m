//
//  DataManager.m
//  Hydroxide
//
//  Created by Craig Stanford on 30/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "AFJSONRequestOperation.h"
#import "Section+Additions.h"

const NSString* kHydroxideConfigSuccess = @"kHydroxideConfigSuccess";
const NSString* kHydroxideConfigFailure = @"kHydroxideConfigFailure";
const NSString* kHydroxideAppRequiresUpdate = @"kHydroxideAppRequiresUpdate";

@implementation DataManager

- (void)updateSections
{
    // Override this URL with your configuration file
    NSURL* url = [NSURL URLWithString:@"http://127.0.0.1/config.json"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation* configOperation = [AFJSONRequestOperation 
                                               JSONRequestOperationWithRequest:request 
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                   if (!JSON) 
                                                   {
                                                       //TODO: Create Error to Post with Notification
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kHydroxideConfigFailure
                                                                                                           object:nil];
                                                       return;
                                                   }
                                                   
                                                   //Delete the old sections
                                                   [Section truncateAll];
                                                   
                                                   //Now create the new ones from the JSON
                                                   NSDictionary* config = JSON;
                                                   NSArray* sectionArray = [config objectForKey:@"sections"];
                                                   for (NSDictionary* sectionDictionary in sectionArray) 
                                                       [Section createSectionWithDictionary:sectionDictionary];
                                                   
                                                   //Save the CoreData Context
                                                   [[NSManagedObjectContext contextForCurrentThread] save];
                                                   
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kHydroxideConfigSuccess 
                                                                                                       object:nil];
                                               }                                                                                               
                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kHydroxideConfigFailure
                                                                                                       object:error];
                                               }];
    NSOperationQueue* queue = [NSOperationQueue mainQueue];
    [queue addOperation:configOperation];
}

SYNTHESIZE_SINGLETON_FOR_CLASS(DataManager);

@end
