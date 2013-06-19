//
//  CameraViewController.h
//  ePic
//
//  Created by Adam Smith on 6/19/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *takePhoto;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectPhoto;

@end
