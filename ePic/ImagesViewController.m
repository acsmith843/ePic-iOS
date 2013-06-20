//
//  ImagesViewController.m
//  ePic
//
//  Created by Adam Smith on 6/18/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "ImagesViewController.h"
#import "ImageCell.h"
#import "UIImageView+AFNetworking.h"

@interface ImagesViewController ()

@end

@implementation ImagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // if there is no camera on the user's device, let the user know instead of crashing
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - collection view delegate methods

-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_albumImages count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCell *imageCell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
//    imageCell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    imageCell.backgroundColor = [UIColor lightGrayColor];
    
    NSURL *url = [NSURL URLWithString:[_albumImages objectAtIndex:indexPath.item]];
    [imageCell.thumbnailView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bluetint.png"]];
    
    return imageCell;
}



#pragma mark - action sheet delegate

-(IBAction)showActionSheet:(id)sender {
    
    // TODO: eventually add option to just use the last photo taken
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:@"Take Photo", @"Add Existing Photo", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
     switch (buttonIndex) {
         case 0:
             // TODO : add delete photo logic
             break;
         case 1:
             [self takePhoto];
             break;
         case 2:             
             [self selectPhoto];
             break;
     }
     
}



#pragma mark - camera methods

- (void) takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}



#pragma mark - image picker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
