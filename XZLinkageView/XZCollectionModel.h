//
//  XZCollectionModel.h
//  XZLinkageView
//
//  Created by codeLocker on 2016/12/22.
//  Copyright © 2016年 codeLocker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZCollectionModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *subcategories;
@end

@interface GoodModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon_url;
@end
