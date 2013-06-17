//
//  ViewController.m
//  ePic
//
//  Created by Adam Smith on 6/10/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "User.h"
#import "Album.h"
#import "AppDelegate.h"
#import "AlbumsViewController.h"
#import "UserManager.h"

@interface LoginViewController ()
@property (nonatomic, strong) User *currentUser;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // register for the session change notification
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(sessionStateChanged:)
        name:FBSessionStateChangedNotification
        object:nil];
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    BOOL signedIn = [APP_DELEGATE openSessionWithAllowLoginUI:NO];
    
    if(signedIn){
        
        int64_t delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissViewControllerAnimated:NO completion:nil];
        });
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // unregister for notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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

- (IBAction)performLogin:(id)sender {
    
//    [self.spinner startAnimating];
    
    [APP_DELEGATE openSessionWithAllowLoginUI:YES];
}

- (void)sessionStateChanged:(NSNotification *)notification {
    
    //if success then dismiss the modal
    if (FBSession.activeSession.isOpen) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
