//
//  TMquestion.h
//  0327
//
//  Created by tim on 2017/9/13.
//  Copyright © 2017年 dream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMquestion : NSObject

@property(nonatomic,copy) NSString *answer;

@property(nonatomic,copy) NSString *icon;

@property(nonatomic,copy) NSString *title;

@property(nonatomic,strong ) NSArray *options;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)questionWithDict:(NSDictionary *)dict;

@end
