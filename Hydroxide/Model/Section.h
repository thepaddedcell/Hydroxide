//
//  Section.h
//  Hydroxide
//
//  Created by Craig Stanford on 30/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Section : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * urlString;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSNumber * position;

@end
