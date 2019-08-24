//
//  ProductModel.m
//  SMTest
//
//  Created by ueMac on 2019/8/3.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.icon = [UIImage imageWithContentsOfFile: dic[@"iconPath"]];
        self.price = [dic[@"price"] floatValue];
        self.name = dic[@"name"];
        self.percent = [dic[@"percent"] floatValue];
    }
    return self;
}

- (instancetype)initWithImg:(UIImage *)img name:(NSString *)name price:(NSString *)price percent:(NSString *)percent
{
    if (self = [super init])
    {
        self.icon = img;
        self.price = [price floatValue];
        self.name = name;
        self.percent = [percent floatValue];
    }
    return self;
}

- (float)allPrice
{
    return self.price * self.count;
}

@end
