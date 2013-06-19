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
    
    NSURL *url = [NSURL URLWithString:[_albumImages objectAtIndex:indexPath.item]];
    [imageCell.thumbnailView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bluetint.png"]];
    
    return imageCell;
}




@end
