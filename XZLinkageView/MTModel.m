//
//  MTModel.m
//  XZLinkageView
//
//  Created by codeLocker on 2016/12/21.
//  Copyright © 2016年 codeLocker. All rights reserved.
//

#import "MTModel.h"

@implementation MTModel

@end

@implementation CategoryModel

+ (NSDictionary *)objectClassInArray{

    return @{@"spus":@"FoodModel"};
}

@end

@implementation FoodModel

+ (NSDictionary *)replacedKeyFromPropertyName{

    return @{@"foodId":@"id"};
}

@end
