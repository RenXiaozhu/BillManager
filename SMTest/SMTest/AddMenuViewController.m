//
//  ManageMenuViewController.m
//  SMTest
//
//  Created by ueMac on 2019/8/3.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import "AddMenuViewController.h"
#import "BGFMDB.h"
#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PhotosDefines.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface AddMenuViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, copy) LeePhotoOrAlbumImagePickerBlock photoBlock;   //-> 回掉
@property (nonatomic, strong) UIImagePickerController *picker; //-> 多媒体选择控制器
@property (nonatomic, weak) UIViewController  *viewController; //-> 一定是weak 避免循环引用
@property (nonatomic, assign) NSInteger sourceType;            //-> 媒体来源 （相册/相机）
@property (nonatomic, strong) UIImage *selectImg;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *percent;
@end

@implementation AddMenuViewController

- (IBAction)selectPhoto:(id)sender {
    __block AddMenuViewController *weakSelf = (AddMenuViewController *)self;
    [self getPhotoAlbumOrTakeAPhotoWithController:self photoBlock:^(UIImage * _Nonnull image) {
        weakSelf.selectImg = image;
        [weakSelf.selectImgBtn setImage:image forState:UIControlStateNormal];
    }];
}

- (IBAction)endEdit:(id)sender {
    UITextField *field = (UITextField *)sender;
    self.name = field.text;
}

- (IBAction)priceEndEdit:(id)sender {
    UITextField *field = (UITextField *)sender;
    self.price = field.text;
}

- (IBAction)percenEndEdit:(id)sender {
    UITextField *field = (UITextField *)sender;
    self.percent = field.text;
}

- (IBAction)save:(id)sender
{
    ProductModel *model = [[ProductModel alloc] initWithImg:self.selectImg name:self.name price:self.price percent:self.percent];
    model.bg_tableName = @"MenuList";
    if ([model bg_saveOrUpdate])
    {
        NSLog(@"菜品保存成功");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"菜品保存失败");
    }
}

- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)controller photoBlock:(LeePhotoOrAlbumImagePickerBlock)photoBlock{
    self.photoBlock = photoBlock;
    self.viewController = controller;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:1];
    }];
    UIAlertAction *cemeraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:2];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:0];
    }];
    [alertController addAction:photoAlbumAction];
    [alertController addAction:cancleAction];
    // 判断是否支持拍照
    [self imagePickerControlerIsAvailabelToCamera] ? [alertController addAction:cemeraAction]:nil;
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}



/**
 UIAlertController 点击事件 确定选择的媒体来源（相册/相机）
 
 @param type 点击的类型
 */
- (void)getAlertActionType:(NSInteger)type {
    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (type == 1) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (type ==2){
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self creatUIImagePickerControllerWithAlertActionType:sourceType];
}



/**
 点击事件出发的方法
 
 @param type 媒体库来源 （相册/相机）
 */
- (void)creatUIImagePickerControllerWithAlertActionType:(NSInteger)type {
    self.sourceType = type;
    // 获取不同媒体类型下的授权类型
    NSInteger cameragranted = [self AVAuthorizationStatusIsGranted];
    // 如果确定未授权 cameragranted ==0 弹框提示；如果确定已经授权 cameragranted == 1；如果第一次触发授权 cameragranted == 2，这里不处理
    if (cameragranted == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置-隐私-相机/相册中打开授权设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
        [alertController addAction:comfirmAction];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }else if (cameragranted == 1) {
        [self presentPickerViewController];
    }
}


// 判断硬件是否支持拍照
- (BOOL)imagePickerControlerIsAvailabelToCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 照机/相册 授权判断
- (NSInteger)AVAuthorizationStatusIsGranted  {
    __block AddMenuViewController * weakSelf = (AddMenuViewController *)self;
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatusVedio = [AVCaptureDevice authorizationStatusForMediaType:mediaType];  // 相机授权
    PHAuthorizationStatus authStatusAlbm  = [PHPhotoLibrary authorizationStatus];                         // 相册授权
    NSInteger authStatus = self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? authStatusAlbm:authStatusVedio;
    switch (authStatus) {
        case 0: { //第一次使用，则会弹出是否打开权限，如果用户第一次同意授权，直接执行再次调起
            if (self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) { //授权成功
                        [weakSelf presentPickerViewController];
                    }
                }];
            }else{
                [AVCaptureDevice requestAccessForMediaType : AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) { //授权成功
                        [weakSelf presentPickerViewController];
                    }
                }];
            }
        }
            return 2;   //-> 不提示
        case 1: return 0; //-> 还未授权
        case 2: return 0; //-> 主动拒绝授权
        case 3: return 1; //-> 已授权
        default:return 0;
    }
}


/**
 如果第一次访问用户是否是授权，如果用户同意 直接再次执行
 */
-(void)presentPickerViewController{
    self.picker = [[UIImagePickerController alloc] init];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;          //-> 是否允许选取的图片可以裁剪编辑
    self.picker.sourceType = self.sourceType; //-> 媒体来源（相册/相机）
    [self.viewController presentViewController:self.picker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
// 点击完成按钮的选取图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 获取编辑后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    // 如果裁剪的图片不符合标准 就会为空，直接使用原图
    image == nil    ?  image = [info objectForKey:UIImagePickerControllerOriginalImage] : nil;
    self.photoBlock ?  self.photoBlock(image): nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        // 这个部分代码 视情况而定
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        // 这个部分代码 视情况而定
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.frame];
    [control addTarget:self action:@selector(resignField) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [self.view insertSubview:control atIndex:0];
    // Do any additional setup after loading the view.
}

- (void)resignField
{
    [self resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.priceField resignFirstResponder];
    [self.percentField resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
