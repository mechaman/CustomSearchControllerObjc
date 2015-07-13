//
//  item.m
//  CustomSearchController
//
//  Created by Julien Hoachuck on 5/7/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "item.h"

@implementation item

-(instancetype) initWithName:(NSString *)name
{
    self = [super init];
    self.name = name;
    return self;
}
@end
