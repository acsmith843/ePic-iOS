//
//  ImagesViewController.h
//  ePic
//
//  Created by Adam Smith on 6/18/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController : UICollectionViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *albumImages;
-(IBAction)showActionSheet:(id)sender;

@end
