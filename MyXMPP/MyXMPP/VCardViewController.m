//
//  VCardViewController.m
//  MyXMPP
//
//  Created by halloworld on 16/1/10.
//  Copyright © 2016年 halloworld. All rights reserved.
//

#import "VCardViewController.h"

@interface VCardViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nicknameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

@end

@implementation VCardViewController


- (IBAction)btnHeaderImageTap:(id)sender {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = info[UIImagePickerControllerEditedImage];
    [self.headerButton setImage:img forState:UIControlStateNormal];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
