//
//  NSObject+Property.m
//  XZLinkageView
//
//  Created by codeLocker on 2016/12/21.
//  Copyright © 2016年 codeLocker. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

+ (instancetype)objectWithDictionary:(NSDictionary *)dic{

    id obj = [[self alloc] init];
    
    //获取所有的成员变量
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self, &count);
    
    for (unsigned int i =0; i < count; i++) {
        
        Ivar ivar = ivars[i];
        
        //取出model的成员变量去除下划线
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *propertyName = [ivarName substringFromIndex:1];
        //取出字典中与key相对应的value
        id value = dic[propertyName];
        //如果value为空，则进行判断是否进行了字段名称的替换
        if (!value) {
            
            if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)]) {
                
                NSString *originKey = [self replacedKeyFromPropertyName][propertyName];
                value = dic[originKey];
            }
        }
        
        //字典嵌套字典
        if ([value isKindOfClass:[NSDictionary class]])
        {
            //获取model对应的数据类型可能是其他model类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            type = [type substringToIndex:range.location];
            Class modelClass = NSClassFromString(type);
            
            if (modelClass)
            {
                value = [modelClass objectWithDictionary:value];
            }
        }
        
        //字典嵌套数组
        if ([value isKindOfClass:[NSArray class]]) {
            
            if ([self respondsToSelector:@selector(objectClassInArray)]) {
                
                NSMutableArray *models = [NSMutableArray array];
                
                NSString *modelName = [self objectClassInArray][propertyName];
                Class modelCalss = NSClassFromString(modelName);
                
                for (NSDictionary *dic in value) {
                    
                    id model = [modelCalss objectWithDictionary:dic];
                    [models addObject:model];
                }
                value = models;
            }
        }
        
        if (value) {
            [obj setValue:value forKey:propertyName];
        }
        
    }
    
    free(ivars);
    return obj;
}
@end
