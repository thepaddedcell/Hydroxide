//
//  Section+Additions.m
//  Hydroxide
//
//  Created by Craig Stanford on 30/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Section+Additions.h"

@implementation Section (Additions)

- (NSURL *)url
{
    return [NSURL URLWithString:[self urlString]];
}

- (NSURLRequest*)urlRequest
{
    return [NSURLRequest requestWithURL:[self url]];
}

+ (Section *)createSectionWithDictionary:(NSDictionary *)dictionary
{
    // Create the new section
    Section* section = [Section createEntity];
    
    //Now populate it with the data
    section.title = [dictionary valueForKey:@"title"];
    section.subtitle = [dictionary valueForKey:@"subtitle"];
    section.urlString = [dictionary valueForKey:@"page"];
    section.position = [NSNumber numberWithInt:[[dictionary valueForKey:@"position"] intValue]];
    
    return section;
}

@end
