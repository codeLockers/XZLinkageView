//
//  NSObject+Property.h
//  XZLinkageView
//
//  Created by codeLocker on 2016/12/21.
//  Copyright © 2016年 codeLocker. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyValue <NSObject>

@optional


/**
 字典中嵌套数组的时候，把数组中的每一个元素转成指定的model

 @return @{数组对应的key:需要转化的model类型}
 */
+ (NSDictionary *)objectClassInArray;


/**
 json数据中的key在model中更换成其他字段

 @return @{model中的属性名:json中的字段}
 */
+ (NSDictionary *)replacedKeyFromPropertyName;

@end


@interface NSObject (Property) <KeyValue>

+ (instancetype)objectWithDictionary:(NSDictionary *)dic;

@end
