//
//  TMquestion.m
//  0327
//
//  Created by tim on 2017/9/13.
//  Copyright © 2017年 dream. All rights reserved.
//

#import "TMquestion.h"

@implementation TMquestion


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.answer = dict[@"answer"];
        self.icon = dict[@"icon"];
        self.title = dict[@"title"];
        self.options = dict[@"options"];
    }
    return self;
}

+ (instancetype)questionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
