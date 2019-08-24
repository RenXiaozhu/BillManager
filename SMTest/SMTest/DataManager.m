//
//  DataManager.m
//  SMTest
//
//  Created by 王傲 on 2019/8/4.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import "DataManager.h"


#define PRODUCT_LIST @"productlist.json"

@interface DataManager ()
@property (nonatomic, strong) NSString *jsonPath;
@property (nonatomic, strong) NSMutableArray *products;
@end

@implementation DataManager

+ (DataManager *)shareInstance
{
    static DataManager *data = nil;
    if (data == nil) {
        data = [[DataManager alloc] init];
    }
    return data;
}

- (instancetype)init
{
    @synchronized (self)
    {
        if (self = [super init]) {
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
			self.jsonPath = [path stringByAppendingPathComponent:PRODUCT_LIST];
            self.products = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSMutableArray *)getProducts
{
    [self.products removeAllObjects];
    [self load];
    return self.products;
}

- (void)addProduct:(ProductModel *)product
{
    [self.products addObject:product];
}

- (void)deleteProduct:(int)index
{
    [self.products removeObjectAtIndex:index];
}

- (void)load
{
   
}

- (void)save
{
    //    如果数组或者字典中存储了  NSString, NSNumber, NSArray, NSDictionary, or NSNull 之外的其他对象,就不能直接保存成文件了.也不能序列化成 JSON 数据.
    // 1.判断当前对象是否能够转换成JSON数据.

    // YES if obj can be converted to JSON data, otherwise NO
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ( [manager fileExistsAtPath:self.jsonPath])
    {
        [manager removeItemAtPath:self.jsonPath error:nil];
    }
    [manager createFileAtPath:self.jsonPath contents:[NSData data] attributes:nil];
   
    BOOL isYes = [NSJSONSerialization isValidJSONObject:self.products];

    if (isYes) 
    {
        NSLog(@"可以转换");

        /* JSON data for obj, or nil if an internal error occurs. The resulting data is a encoded in UTF-8.

         */

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.products options:0 error:NULL];

        /*

         Writes the bytes in the receiver to the file specified by a given path.

         YES if the operation succeeds, otherwise NO

         */

        // 将JSON数据写成文件

        // 文件添加后缀名: 告诉别人当前文件的类型.

        // 注意: AFN是通过文件类型来确定数据类型的!如果不添加类型,有可能识别不了! 自己最好添加文件类型.

        //        [jsonData writeToFile:@"/Users/xyios/Desktop/dict.json" atomically:YES];

        //存入NSDocumentDirectory

        //储存文件名称+格式

        NSLog(@"savePath is SY:%@", self.jsonPath);

        [jsonData writeToFile:self.jsonPath atomically:YES];

        NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    }
	else
	{
        NSLog(@"JSON数据生成失败，请检查数据格式");
    }
}

@end
