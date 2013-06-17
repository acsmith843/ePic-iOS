//
//  UserManager.m
//  ePic
//
//  Created by Adam Smith on 6/13/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "UserManager.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "User.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation UserManager



#pragma mark - remote calls

- (void) findUserByFacebookIdcompletion:(void (^)(BOOL success))callbackBlock {
    
    //Starts a connection to Facebook API so we can grab the details off the fb user and check for existing token
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         
         if (!error) {
             
             NSLog(@"successful fb login - open session %@", user);
             
             NSURL *urlString = [NSURL URLWithString:URL_LOCAL_BASE];
             
             AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
             [httpClient setParameterEncoding:AFJSONParameterEncoding];
             
             // pull facebook id and query db to see if a user with this id already exists
             NSString *fullPath = [NSString stringWithFormat:@"user/fb/%@", [user objectForKey:@"id"]];
             NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:fullPath parameters:nil];
             
             AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                 
                 NSLog(@"Success %@", JSON);
                 [self populateAndSetCurrentUser:JSON];
                 
                 if (callbackBlock != nil) {
                     callbackBlock(YES);
                 }
                 
             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                 
                 NSLog(@"No ePic User Found %@%@%@%@", request, response, error, JSON);
                 [self createUser : user];
                 
             }];
             
             [operation start];
         }
         
     }];
}


- (void) createUser : (NSDictionary<FBGraphUser> *) user {
    
    NSLog(@"About to create user! %@", user);
    
    NSURL *urlString = [NSURL URLWithString:URL_LOCAL_BASE];
    
    NSDictionary *dic = @{@"firstName" : [user objectForKey:@"name"],
                          @"lastName" : [user objectForKey:@"name"],
                          @"eMail" : [user objectForKey:@"email"],
                          @"facebookId" : [user objectForKey:@"id"]
                          };
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"user" parameters:dic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success %@", JSON);
        [self populateAndSetCurrentUser:JSON];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failure %@%@%@%@", request, response, error, JSON);
        
    }];
    
    [operation start];
}



#pragma mark - utility methods

-(void) populateAndSetCurrentUser : (id) JSON {
    
    User *currentUser = [[User alloc] init];
    currentUser.uuid = [JSON valueForKeyPath:@"id"];
    currentUser.firstName = [JSON valueForKeyPath:@"firstName"];
    currentUser.lastName = [JSON valueForKeyPath:@"lastName"];
    currentUser.eMail = [JSON valueForKeyPath:@"eMail"];
    currentUser.albums = [JSON valueForKeyPath:@"albums"];
    
    APP_DELEGATE.currentUser = [[User alloc] init];
    NSLog(@"current user UM: %@", currentUser);
    APP_DELEGATE.currentUser = currentUser;
    NSLog(@"AD user UM: %@", APP_DELEGATE.currentUser);
}

@end
