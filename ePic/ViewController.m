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

@interface ViewController ()

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

- (IBAction)testRemoteCall:(id)sender {
    
    NSURL *urlString = [NSURL URLWithString:@"http://localhost:9000/v1/"];
    
    NSDictionary *userDic = @{@"firstName" : @"Adam",
                             @"lastName" : @"Smith",
                             @"eMail" : @"eMail"
                             };
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlString];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"users" parameters:userDic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success %@", JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failure %@%@%@%@", request, response, error, JSON);
        
    }];
    
    [operation start];
}

@end
