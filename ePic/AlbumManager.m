//
//  AlbumManager.m
//  ePic
//
//  Created by Adam Smith on 6/17/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "AlbumManager.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "Album.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation AlbumManager

- (void)createAlbum:(NSDictionary *) albumDic completion:(void (^)(BOOL))callbackBlock {
    
    NSURL *urlString = [NSURL URLWithString:URL_LOCAL_BASE];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"album" parameters:albumDic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Successfully created new album %@", JSON);
        
        NSDictionary *createdAlbum = JSON;
        
        // make sure we add the new album to our current user
        NSMutableArray *albumsArray = [[NSMutableArray alloc] initWithArray:APP_DELEGATE.currentUser.albums];
        [albumsArray addObject:createdAlbum];
        [APP_DELEGATE.currentUser setAlbums:albumsArray];
        
        if (callbackBlock != nil) {
            callbackBlock(YES);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failure %@%@%@%@", request, response, error, JSON);
        
    }];
    
    [operation start];
}

@end
