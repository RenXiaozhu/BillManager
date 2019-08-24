//
//  ProductModel.h
//  SMTest
//
//  Created by ueMac on 2019/8/3.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BGFMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProductModel : NSObject
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) float price;
@property (assign, nonatomic) float percent;
@property (assign, nonatomic) int count;
@property (assign, nonatomic) float allPrice;
@property (strong, nonatomic) NSDate *date;

- (instancetype)initWithImg:(UIImage *)img name:(NSString *)name price:(NSString *)price percent:(NSString *)percent;
@end

NS_ASSUME_NONNULL_END
