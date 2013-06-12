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

@interface AlbumsViewController ()
@property (nonatomic, strong) NSMutableArray *albumArray;
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
    
    // Grab the albums off our user object
    [self populateAlbumArray];
    
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
    albumOwner.text = [NSString stringWithFormat:@"Owned By: %@", album.ownerId];
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



#pragma mark - Remote Calls

- (void) findAlbumsForUser {
    
    NSURL *urlString = [NSURL URLWithString:@"http://localhost:9000/v1/albums/"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"2" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success %@", JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failure %@%@%@%@", request, response, error, JSON);
        
    }];
    
    [operation start];
}

- (IBAction)createAlbum:(id)sender {
    
    NSURL *urlString = [NSURL URLWithString:@"http://localhost:9000/v1/"];
    
    NSDictionary *userDic = @{@"title" : @"My First Album",
                              @"ownerId" : @"1"
                              };
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"album" parameters:userDic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success %@", JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failure %@%@%@%@", request, response, error, JSON);
        
    }];
    
    [operation start];
}



#pragma mark - utility methods
// parses the album json and popu
- (void) populateAlbumArray {
    
    NSMutableArray *userAlbums = [[NSMutableArray alloc] init];
    for (NSDictionary *albumDic in APP_DELEGATE.currentUser.albums) {
        Album *album = [[Album alloc] init];
        album.title = [albumDic objectForKey:@"title"];
        album.ownerId = [albumDic objectForKey:@"ownerId"];
        [userAlbums addObject:album];
    }
    
    _albumArray = userAlbums;
    
}

@end
