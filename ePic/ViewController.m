//
//  ViewController.m
//  ePic
//
//  Created by Adam Smith on 6/10/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "User.h"
#import "Album.h"
#import "AppDelegate.h"
#import "AlbumsViewController.h"

@interface ViewController ()
@property (nonatomic, strong) User *currentUser;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self findUser];
    
}

- (IBAction)testRemoteCall:(id)sender {
    
    NSURL *urlString = [NSURL URLWithString:@"http://localhost:9000/v1/"];
    
    NSDictionary *dic = @{@"title" : @"My First Album",
                          @"ownerId" : @"1"
                          };
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"album" parameters:dic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success %@", JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failure %@%@%@%@", request, response, error, JSON);
        
    }];
    
    [operation start];
}

- (void) findUser {
    
    NSURL *urlString = [NSURL URLWithString:@"http://localhost:9000/v1/user/"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"1" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success %@", JSON);
        User *currentUser = [[User alloc] init];
        currentUser.firstName = [JSON valueForKeyPath:@"firstName"];
        currentUser.lastName = [JSON valueForKeyPath:@"lastName"];
        currentUser.eMail = [JSON valueForKeyPath:@"eMail"];
        currentUser.albums = [JSON valueForKeyPath:@"albums"];
        
        APP_DELEGATE.currentUser = [[User alloc] init];
        NSLog(@"current user: %@", currentUser);
        APP_DELEGATE.currentUser = currentUser;
        NSLog(@"AD user: %@", APP_DELEGATE.currentUser);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failure %@%@%@%@", request, response, error, JSON);
        
    }];
    
    [operation start];
}

@end
