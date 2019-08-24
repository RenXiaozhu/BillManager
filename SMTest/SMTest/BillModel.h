//
//  BillModel.h
//  SMTest
//
//  Created by MacMini2 on 2019/8/19.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
#import "ProductModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BillModel : NSObject
@property (nonatomic, assign) float allPrice;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray <ProductModel*>*list;

- (float)allPrice;
@end

NS_ASSUME_NONNULL_END
