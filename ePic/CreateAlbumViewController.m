//
//  CreateAlbumViewController.m
//  ePic
//
//  Created by Adam Smith on 6/17/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "CreateAlbumViewController.h"
#import "AppDelegate.h"
#import "AlbumManager.h"

@interface CreateAlbumViewController ()
@property (nonatomic, weak) IBOutlet UITextField *albumTitle;
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



#pragma mark - manager calls

- (IBAction)createAlbum:(id)sender {
        
    NSDictionary *albumDic = @{@"title" : _albumTitle.text,
                               @"ownerId" : APP_DELEGATE.currentUser.uuid,
                               @"ownerName" : APP_DELEGATE.currentUser.name
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
