//
//  item.h
//  CustomSearchController
//
//  Created by Julien Hoachuck on 5/7/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface item : NSObject
@property (nonatomic, strong) NSString *name;

-(instancetype) initWithName:(NSString *)name;

@end
