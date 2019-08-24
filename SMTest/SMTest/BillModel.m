//
//  BillModel.m
//  SMTest
//
//  Created by MacMini2 on 2019/8/19.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import "BillModel.h"

@implementation BillModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.list = [[NSMutableArray alloc] init];
        self.date = [NSDate date];
    }
    return self;
}

- (float)allPrice
{
    if ([self.list count] != 0)
    {
        float price = 0;
        for (ProductModel *model in self.list)
        {
            price += model.allPrice;
        }
        return price;
    }
    else
    {
        return 0;
    }
}
@end
