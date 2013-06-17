//
//  CreateAlbumViewController.m
//  ePic
//
//  Created by Adam Smith on 6/17/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "CreateAlbumViewController.h"
#import "Album.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AlbumManager.h"

@interface CreateAlbumViewController ()
@property (weak, nonatomic) IBOutlet UITextField *albumTitle;
@end

@implementation CreateAlbumViewController

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

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}



#pragma mark - remote calls

- (IBAction)createAlbum:(id)sender {
        
    NSDictionary *albumDic = @{@"title" : _albumTitle.text,
                          @"ownerId" : APP_DELEGATE.currentUser.uuid
                          };
    
    AlbumManager *albumManager = [[AlbumManager alloc] init];
    [albumManager createAlbum:albumDic completion:^(BOOL success){
        
        if (success) {
            // takes us back to albums list
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Error creating album");
        }
        
    }];
    
}


@end
