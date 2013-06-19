//
//  AlbumsViewController.m
//  ePic
//
//  Created by Adam Smith on 6/11/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "User.h"
#import "Album.h"
#import "AppDelegate.h"
#import "UserManager.h"
#import "ImagesViewController.h"

@interface AlbumsViewController ()
@property (nonatomic, weak) IBOutlet UITableView *albumTable;
@property (nonatomic, strong) NSMutableArray *albumArray;
@property (nonatomic, strong) NSMutableArray *chosenAlbumImages;
@end

@implementation AlbumsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    if (FBSession.activeSession.isOpen && APP_DELEGATE.currentUser == nil) {
        
        UserManager *userManager = [[UserManager alloc] init];
        [userManager findUserByFacebookIdcompletion:^(BOOL success){
            
            if (success) {
                [self populateAlbumArray];  
            } else {
                NSLog(@"Could not find user by fb id");
            }
            
        }];

    } else if (FBSession.activeSession.isOpen && APP_DELEGATE.currentUser != nil) {
        [self populateAlbumArray];
    } else {
        [self performSegueWithIdentifier:@"loginModal" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Album *album = [_albumArray objectAtIndex:indexPath.row];
    // Display title
    UILabel *albumTitle = (UILabel *)[cell viewWithTag:100];
    albumTitle.text = album.title;
    // Display owner
    UILabel *albumOwner = (UILabel *)[cell viewWithTag:101];
    albumOwner.text = [NSString stringWithFormat:@"Owned By: %@", album.ownerName];
    // Display creation date
    UILabel *albumCreateDate = (UILabel *)[cell viewWithTag:102];
    albumCreateDate.text = @"6/20/1984";
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    Album *chosenAlbum = [self.albumArray objectAtIndex:indexPath.row];
    _chosenAlbumImages = [[NSMutableArray alloc] initWithArray:chosenAlbum.images];
    [_chosenAlbumImages addObject:@"http://3.bp.blogspot.com/-iDeA6LO0YrU/UDedd7dX29I/AAAAAAAABi0/ridmpc2Awz8/s1600/boxer-dogs-1.jpg"];
    
//    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
//    [flow setItemSize:CGSizeMake(60, 60)];
//    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    
//    ImagesViewController *imagesViewController = [[ImagesViewController alloc] initWithCollectionViewLayout:flow];
//    imagesViewController.albumImages = testArray;
//    
//    // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:imagesViewController animated:YES];
    
    [self performSegueWithIdentifier:@"imageSegue" sender:indexPath];
}



#pragma mark - FBUserSettingsDelegate methods

- (void)loginViewController:(id)sender receivedError:(NSError *)error{
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)loginViewControllerDidLogUserOut:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}



#pragma mark - utility methods

- (void) populateAlbumArray {
    
    NSMutableArray *userAlbums = [[NSMutableArray alloc] init];
    for (NSDictionary *albumDic in APP_DELEGATE.currentUser.albums) {
        Album *album = [[Album alloc] init];
        album.title = [albumDic objectForKey:@"title"];
        album.ownerId = [albumDic objectForKey:@"ownerId"];
        album.ownerName = [albumDic objectForKey:@"ownerName"];
        [userAlbums addObject:album];
    }
    
    _albumArray = userAlbums;
    
    [self.albumTable reloadData];
    
}



#pragma mark - segue methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"imageSegue"]) {
        
        [[segue destinationViewController] setAlbumImages:_chosenAlbumImages];
    }
    
}

@end
