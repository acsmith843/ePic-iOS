//
//  CreateAlbumViewController.m
//  ePic
//
//  Created by Adam Smith on 6/17/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "CreateAlbumViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "Album.h"
#import "AppDelegate.h"
#import "Constants.h"

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
    
    NSURL *urlString = [NSURL URLWithString:URL_LOCAL_BASE];
    
    NSDictionary *dic = @{@"title" : _albumTitle.text,
                          @"ownerId" : @"1"
                          };
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"album" parameters:dic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Successfully created new album %@", JSON);
        
        NSDictionary *createdAlbum = JSON;
        
        // make sure we add the new album to our current user
        NSMutableArray *albumsArray = [[NSMutableArray alloc] initWithArray:APP_DELEGATE.currentUser.albums];
        [albumsArray addObject:createdAlbum];
        [APP_DELEGATE.currentUser setAlbums:albumsArray];
        
        // takes us back to albums list
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failure %@%@%@%@", request, response, error, JSON);
        
    }];
    
    [operation start];
}


@end
