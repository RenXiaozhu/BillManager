//
//  DataManager.h
//  SMTest
//
//  Created by 王傲 on 2019/8/4.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+ (DataManager *)shareInstance;
- (NSMutableArray *)getProducts;
- (void)addProduct:(ProductModel *)product;
- (void)deleteProduct:(int)index;
- (NSMutableArray *)getTodayBill;
- (NSMutableArray *)getAllBills;

@end

NS_ASSUME_NONNULL_END
