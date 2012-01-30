//
//  Section+Additions.h
//  Hydroxide
//
//  Created by Craig Stanford on 30/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Section.h"

@interface Section (Additions)

- (NSURL*)url;
- (NSURLRequest*)urlRequest;

+ (Section *)createSectionWithDictionary:(NSDictionary*)dictionary;

@end
