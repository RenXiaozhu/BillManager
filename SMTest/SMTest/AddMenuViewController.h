//
//  ManageMenuViewController.h
//  SMTest
//
//  Created by ueMac on 2019/8/3.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^LeePhotoOrAlbumImagePickerBlock)(UIImage *image);

@interface AddMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *selectImgBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *percentField;
@property (strong, nonatomic) IBOutlet UIView *saveBtn;

// 必须创建一个对象才行，才不会释放指针
// 必须先在使用该方法的控制器中初始化 创建这个属性，然后在对象调用如下方法

/**
 公共方法 选择图片后的图片回掉
 
 @param controller 使用这个工具的控制器
 @param photoBlock 选择图片后的回掉
 */
- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)controller photoBlock:(LeePhotoOrAlbumImagePickerBlock)photoBlock;
@end

NS_ASSUME_NONNULL_END
