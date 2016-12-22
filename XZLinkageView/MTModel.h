//
//  MTModel.h
//  XZLinkageView
//
//  Created by codeLocker on 2016/12/21.
//  Copyright © 2016年 codeLocker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTModel : NSObject

@end

@interface CategoryModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSArray *spus;

@end

@interface FoodModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *foodId;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, assign) NSInteger praise_content;
@property (nonatomic, assign) NSInteger month_saled;
@property (nonatomic, assign) float min_price;


@end
